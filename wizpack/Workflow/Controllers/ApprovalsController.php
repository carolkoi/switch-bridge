<?php

namespace WizPack\Workflow\Controllers;

use Illuminate\Support\Facades\Auth;
use WizPack\Workflow\DataTables\ApprovalsDataTable;
use WizPack\Workflow\Requests\CreateApprovalsRequest;
use WizPack\Workflow\Requests\UpdateApprovalsRequest;
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
    }

    /**
     * Display a listing of the Approvals.
     *
     * @param ApprovalsDataTable $approvalsDataTable
     * @return Response
     */
    public function index(ApprovalsDataTable $approvalsDataTable)
    {
        dd( \auth()->user()->name);
        return $approvalsDataTable->render('workflow.approvals.index');
    }

    /**
     * Show the form for creating a new Approvals.
     *
     * @return Response
     */
    public function create()
    {
        return view('workflow.approvals.create');
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

        $approvals = $this->approvalsRepository->create($input);

        Flash::success('Approvals saved successfully.');

        return redirect(route('workflow.approvals.index'));
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
        $workflow = $this->approvalsRepository->getApprovalSteps($id)->get();

        $transformedResult = new Collection($workflow, new ApprovalTransformer());

        $data = collect((new Manager())->createData($transformedResult)->toArray()['data']);

        $currentStage = $data->pluck('currentApprovalStage')->first();

        $approvers = $data->pluck('currentStageApprovers')->flatten(2);

        $approvals = $data->pluck('approvalStagesStepsAndApprovers')->flatten(1);

        $workflow = $data->pluck('workflowDetails')->first();

        if (empty($approvals)) {
            Flash::error('Approvals not found');

            return redirect(route('approvals.index'));
        }

        return view('workflow.approvals.show', compact('approvals', 'workflow', 'approvers','currentStage'));
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

            return redirect(route('approvals.index'));
        }

        return view('workflow.approvals.edit')->with('approvals', $approvals);
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

            return redirect(route('approvals.index'));
        }

        $approvals = $this->approvalsRepository->update($request->all(), $id);

        Flash::success('Approvals updated successfully.');

        return redirect(route('approvals.index'));
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

            return redirect(route('approvals.index'));
        }

        $this->approvalsRepository->delete($id);

        Flash::success('Approvals deleted successfully.');

        return redirect(route('approvals.index'));
    }
}
