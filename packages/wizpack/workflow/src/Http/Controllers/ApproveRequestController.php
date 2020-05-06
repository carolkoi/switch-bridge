<?php

namespace WizPack\Workflow\Http\Controllers;

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
//        dd($kdata[0]['model_id']);

        $transformedResult = new Collection($workflow, new ApprovalTransformer());

        $data = collect((new Manager())->createData($transformedResult)->toArray()['data']);

        $approvers = $data->pluck('currentStageApprovers')->flatten(2);

        $currentStage = $data->pluck('currentApprovalStage')->flatten(1)->first();

        if (!$approvers->contains('user_id', auth()->id())) {
            Flash::error('You are not authorized to approve this request');

            return redirect('/wizpack/approvals/' . $workflowApprovalId);
        }

        $workflowStageToBeApproved = $data->pluck('currentApprovalStage')->flatten(1)->first();

        $workflow = $data->pluck('workflowDetails')->first();

        $stageId = $workflowStageToBeApproved['workflow_stage_type_id'] ?: $stageId;

        if($request->session()->has('txn_status') && $request->session()->has('aml_listed') && $request->session()->has('remarks')) {
//            dd(session('txn_status'), session('aml_listed'), session('remarks'));
            $transaction = Transactions::where('iso_id', $kdata[0]['model_id'])->update([
                'res_field48' => session('txn_status'),
                'aml_listed' => session('aml_listed'),
                'res_field44' => session('remarks'),
                'date_time_modified' => session('date_time_modified'),
                'modified_by' => session('modified_by')
            ]);
//            dd($transaction);
        }

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

            event(new WorkflowStageApproved($data, $approvedStep));

            Flash::success('Transaction Request Approved successfully');
            return redirect('/wizpack/approvals/' . $workflowApprovalId);
        }

        Flash::success('An error occurred Transaction Request not approved ');
        return redirect()->back();

    }
}
