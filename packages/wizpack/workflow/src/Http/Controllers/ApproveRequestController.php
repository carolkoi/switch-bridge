<?php

namespace WizPack\Workflow\Http\Controllers;

use App\Models\ApiTransaction;
use App\Models\FloatBalance;
use App\Models\SessionTxn;
use App\Models\Transactions;
use Illuminate\Http\Request;
use WizPack\Workflow\Events\WorkflowStageApproved;
use WizPack\Workflow\Repositories\ApprovalsRepository;
use WizPack\Workflow\Repositories\WorkflowStageApproversRepository;
use WizPack\Workflow\Repositories\WorkflowStepRepository;
use WizPack\Workflow\Transformers\ApprovalTransformer;
use Carbon\Carbon;
use Illuminate\Http\RedirectResponse;
use League\Fractal\Resource\Collection;
use Laracasts\Flash\Flash;
use League\Fractal\Manager;
use Prettus\Validator\Exceptions\ValidatorException;
use DB;

class ApproveRequestController extends AppBaseController
{
    /** @var  ApprovalsRepository */
    private $approvalsRepository;
    private $approversRepository;
    private $workflowStepRepository;

    public function __construct(
        ApprovalsRepository $approvalsRepo,
        WorkflowStageApproversRepository $approversRepository,
        WorkflowStepRepository $workflowStepRepository

    )
    {
        $this->approvalsRepository = $approvalsRepo;
        $this->approversRepository = $approversRepository;
        $this->workflowStepRepository = $workflowStepRepository;
        $this->middleware('auth');
    }

    /**
     * @param $workflowApprovalId
     * @param $stageId
     * @param $request
     * @return RedirectResponse
     * @throws ValidatorException
     */
    public function handle($workflowApprovalId, $stageId, Request $request)
    {
        $workflow = $this->approvalsRepository->getApprovalSteps($workflowApprovalId)->get();
        $kdata = $workflow->toArray();

        $transformedResult = new Collection($workflow, new ApprovalTransformer());


        $data = collect((new Manager())->createData($transformedResult)->toArray()['data']);

        $approvers = $data->pluck('currentStageApprovers')->flatten(2);

        $currentStage = $data->pluck('currentApprovalStage')->flatten(1)->first();

        if (!$approvers->contains('user_id', auth()->id())) {
            Flash::error('You are not authorized to approve this request');

            return redirect('/upesi/approvals/' . $workflowApprovalId);
        }

        $workflowStageToBeApproved = $data->pluck('currentApprovalStage')->flatten(1)->first();

        $workflow = $data->pluck('workflowDetails')->first();
        $stageId = $workflowStageToBeApproved['workflow_stage_type_id'] ?: $stageId;
//        dd('here', $workflow);
        if ($workflow['workflow_type'] = 'float_top_up_approval') {
            $news2 = FloatBalance::orderBy('floattransactionid', 'desc')->skip(1)->take(1)->get();
            $latest_record = collect($news2[0])->toArray();
            $latest_run_bal = $latest_record['runningbal'];
            $new_record_credit = FloatBalance::all()->last()->credit;
            $new_record_run_bal = $latest_run_bal + $new_record_credit;
            $float_dets = FloatBalance::find($kdata[0]['model_id']);
            $approvedStep = $this->workflowStepRepository->updateOrCreate([
                'workflow_stage_id' => $stageId,
                'workflow_id' => $workflow['id'],
                'weight' => $currentStage['weight'],
                'user_id' => auth()->id()

            ], [
                'workflow_stage_id' => $stageId,
                'workflow_id' => $workflow['id'],
                'user_id' => auth()->id(),
                'approved_at' => Carbon::now()

            ]);

            if ($approvedStep) {

//            event(new WorkflowStageApproved($data, $approvedStep));
                $approval = $this->approvalsRepository->updateOrCreate(
                    [
                        'id' => $workflow['id']
                    ], [
                    'approved' => 1,
                    'approved_at' => Carbon::now()
                ]);
//                dd('here', $float_dets);
            }
            FloatBalance::where('floattransactionid', $kdata[0]['model_id'])
                ->update([
                    'approved' => 1,
                    'runningbal' => $new_record_run_bal,
                ]);
            Flash::success('Float Top Up Request Approved successfully');
            return redirect('/upesi/approvals/' . $workflowApprovalId);
        }

        $txn = Transactions::where('iso_id', $kdata[0]['model_id'])->first();
        $sessionTxn = SessionTxn::where('txn_id', $kdata[0]['model_id'])->first();
        $uniqRef= DB::select('SELECT fn_generate_ref(?)', [$txn->res_field37]);

        $approvedStep = $this->workflowStepRepository->updateOrCreate([
            'workflow_stage_id' => $stageId,
            'workflow_id' => $workflow['id'],
            'weight' => $currentStage['weight'],
            'user_id' => auth()->id()

        ], [
            'workflow_stage_id' => $stageId,
            'workflow_id' => $workflow['id'],
            'user_id' => auth()->id(),
            'approved_at' => Carbon::now()

        ]);

        if ($approvedStep) {

//            event(new WorkflowStageApproved($data, $approvedStep));
            $approval = $this->approvalsRepository->updateOrCreate(
                [
                    'id' => $workflow['id']
                ],[
                'approved' => 1,
                'approved_at' => Carbon::now()
            ]);

//        dd($uniqRef[0]->fn_generate_ref);

        if($txn->res_field48 == "UPLOAD-FAILED" && $sessionTxn->txn_status == "AML-APPROVED"){
            $api_txn = ApiTransaction::where('transaction_number', $txn->req_field37)->update([
                'transaction_number' => $uniqRef[0]->fn_generate_ref,
                'synced' => false,
            ]);
            $transaction = Transactions::where('iso_id', $kdata[0]['model_id'])->update([
                'res_field48' => $sessionTxn->txn_status,
                'res_field44' => $sessionTxn->comments,
//                'date_time_modified' => strtotime('now'),
                'sent' => false,
                'received' => false,
                'res_field39' => '10',
                'aml_listed' => false,
                'req_field37' => $uniqRef[0]->fn_generate_ref,
                'sync_message' => $sessionTxn->sync_message
            ]);

        }
        elseif($sessionTxn->txn_status == "AML-APPROVED") {
            $transaction = Transactions::where('iso_id', $kdata[0]['model_id'])->update([
                'res_field48' => $sessionTxn->txn_status,
                'res_field44' => $sessionTxn->comments,
                'sent' => false,
                'received' => false,
                'res_field39' => '10',
                'aml_listed' => false,
                'sync_message' => $sessionTxn->sync_message
            ]);
        }
        elseif($sessionTxn->txn_status == "COMPLETED") {
            $transaction = Transactions::where('iso_id', $kdata[0]['model_id'])->update([
                'res_field48' => $sessionTxn->txn_status,
                'res_field44' => $sessionTxn->comments,
                'sync_message' => $sessionTxn->sync_message,
                'res_field39' => '00',
                'paid_out_date' => Carbon::now()
            ]);
        }
        else
            $transaction = Transactions::where('iso_id', $kdata[0]['model_id'])->update([
                'res_field48' => $sessionTxn->txn_status,
//                'aml_listed' => session('aml_listed'),
                'res_field44' => $sessionTxn->comments,
                'sent' => true,
                'received' => true,
                'res_field39' => '06',
                'aml_listed' => true,
                'sync_message' => $sessionTxn->sync_message
            ]);

            Flash::success('Transaction Request Approved successfully');
            return redirect('/upesi/approvals/' . $workflowApprovalId);
        }
        Flash::success('An error occurred Transaction Approval Request not Successful');
        return redirect()->back();


    }
}
