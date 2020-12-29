<?php

namespace WizPack\Workflow\Http\Controllers;

use App\Models\SessionTxn;
use Illuminate\Support\Facades\Auth;
use WizPack\Workflow\DataTables\ApprovalsDataTable;
use WizPack\Workflow\Http\Requests\CreateApprovalsRequest;
use WizPack\Workflow\Http\Requests\UpdateApprovalsRequest;
use WizPack\Workflow\Repositories\ApprovalsRepository;
use WizPack\Workflow\Transformers\ApprovalTransformer;
use Exception;
use Illuminate\Auth\Access\Response;
use Laracasts\Flash\Flash;
use League\Fractal\Manager;
use League\Fractal\Resource\Collection;
use Prettus\Validator\Exceptions\ValidatorException;

class ApprovalsController extends AppBaseController
{
    /** @var  ApprovalsRepository */
    private $approvalsRepository;

    public function __construct(ApprovalsRepository $approvalsRepo)
    {
        $this->approvalsRepository = $approvalsRepo;
        $this->middleware('auth');
    }

    /**
     * Display a listing of the Approvals.
     *
     * @param ApprovalsDataTable $approvalsDataTable
     * @return Response
     */
    public function index(ApprovalsDataTable $approvalsDataTable)
    {
        return $approvalsDataTable->render('wizpack::approvals.index');
    }

    /**
     * Show the form for creating a new Approvals.
     *
     * @return Response
     */
    public function create()
    {
        return view('wizpack::approvals.create');
    }

    /**
     * Store a newly created Approvals in storage.
     *
     * @param CreateApprovalsRequest $request
     *
     * @return Response
     * @throws ValidatorException
     */
    public function store(CreateApprovalsRequest $request)
    {
        $input = $request->all();
        $input['company_id'] = Auth::user()->company_id;

        $approvals = $this->approvalsRepository->create($input);

        Flash::success('Approvals saved successfully.');

        return redirect(route('upesi::approvals.index'));
    }

    /**
     * Display the specified Approvals.
     *
     * @param int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $xyw = collect($this->approvalsRepository->where('id', $id)->get())->toArray();
//        dd($xyw[0]['workflow_type']);
        if ($xyw[0]['workflow_type'] == 'float_top_up_approval') {
            $workflow = $this->approvalsRepository->getFloatApprovalSteps($id)->get();
//            dd($workflow);

            $transformedResult = new Collection($workflow, new ApprovalTransformer());

            $data = collect((new Manager())->createData($transformedResult)->toArray()['data']);

            $currentStage = $data->pluck('currentApprovalStage')->first();

            $approvers = $data->pluck('currentStageApprovers')->flatten(2);

            $approvals = $data->pluck('approvalStagesStepsAndApprovers')->flatten(1);
//        dd($approvals);

            $workflow = $data->pluck('workflowDetails')->first();

            $transaction = $data->pluck('workflowInfo')->first();

            $approvalHasBeenRejected = $data->pluck('approvalRejected')->first();

        } elseif ($xyw[0]['workflow_type'] == 'transaction_approval') {
//            dd('here');
            $workflow = $this->approvalsRepository->getApprovalSteps($id)->get();


//         $workflow = $this->approvalsRepository->getApprovalSteps($id)->get();

            $transformedResult = new Collection($workflow, new ApprovalTransformer());

            $data = collect((new Manager())->createData($transformedResult)->toArray()['data']);

            $currentStage = $data->pluck('currentApprovalStage')->first();

            $approvers = $data->pluck('currentStageApprovers')->flatten(2);

            $approvals = $data->pluck('approvalStagesStepsAndApprovers')->flatten(1);
//        dd($approvals);

            $workflow = $data->pluck('workflowDetails')->first();

            $transaction = $data->pluck('workflowInfo')->first();

            $approvalHasBeenRejected = $data->pluck('approvalRejected')->first();
            $sessionTxn = SessionTxn::where('txn_id', $transaction->iso_id)->first();
        }
            if (empty($approvals)) {
                Flash::error('Approvals not found');

                return redirect(route('upesi::approvals.index'));
            }
//        dd('there',$workflow['workflow_type'] );

            return view('wizpack::approvals.show', compact(
                    'approvals',
                    'workflow',
                    'approvers',
                    'currentStage',
                    'approvalHasBeenRejected',
                    'transaction',
                    'sessionTxn'
                )
            );
        }

    /**
     * Show the form for editing the specified Approvals.
     *
     * @param int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $approvals = $this->approvalsRepository->myApprovals()->find($id);

        if (empty($approvals)) {
            Flash::error('Approvals not found');

            return redirect(route('upesi::approvals.index'));
        }

        return view('wizpack::approvals.edit')->with('approvals', $approvals);
    }

    /**
     * Update the specified Approvals in storage.
     *
     * @param int $id
     * @param UpdateApprovalsRequest $request
     *
     * @return Response
     * @throws ValidatorException
     */
    public function update($id, UpdateApprovalsRequest $request)
    {

        $approvals = $this->approvalsRepository->myApprovals()->find($id);

        if (empty($approvals)) {
            Flash::error('Approvals not found');

            return redirect(route('upesi::approvals.index'));
        }

        $approvals = $this->approvalsRepository->update($request->all(), $id);

        Flash::success('Approvals updated successfully.');

        return redirect(route('upesi::approvals.index'));
    }

    /**
     * Remove the specified Approvals from storage.
     *
     * @param int $id
     *
     * @return Response
     * @throws Exception
     */
    public function destroy($id)
    {
        $approvals = $this->approvalsRepository->myApprovals()->find($id);

        if (empty($approvals)) {
            Flash::error('Approvals not found');

            return redirect(route('upesi::approvals.index'));
        }

        $this->approvalsRepository->delete($id);

        Flash::success('Approvals deleted successfully.');

        return redirect(route('upesi::approvals.index'));
    }
}
