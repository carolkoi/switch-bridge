<?php

namespace App\Http\Controllers;

use App\DataTables\ApprovalWorkflowDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateApprovalWorkflowRequest;
use App\Http\Requests\UpdateApprovalWorkflowRequest;
use App\Repositories\ApprovalWorkflowRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class ApprovalWorkflowController extends AppBaseController
{
    /** @var  ApprovalWorkflowRepository */
    private $approvalWorkflowRepository;

    public function __construct(ApprovalWorkflowRepository $approvalWorkflowRepo)
    {
        $this->approvalWorkflowRepository = $approvalWorkflowRepo;
    }

    /**
     * Display a listing of the ApprovalWorkflow.
     *
     * @param ApprovalWorkflowDataTable $approvalWorkflowDataTable
     * @return Response
     */
    public function index(ApprovalWorkflowDataTable $approvalWorkflowDataTable)
    {
        return $approvalWorkflowDataTable->render('approval_workflows.index');
    }

    /**
     * Show the form for creating a new ApprovalWorkflow.
     *
     * @return Response
     */
    public function create()
    {
        return view('approval_workflows.create');
    }

    /**
     * Store a newly created ApprovalWorkflow in storage.
     *
     * @param CreateApprovalWorkflowRequest $request
     *
     * @return Response
     */
    public function store(CreateApprovalWorkflowRequest $request)
    {
        $input = $request->all();

        $approvalWorkflow = $this->approvalWorkflowRepository->create($input);

        Flash::success('Approval Workflow saved successfully.');

        return redirect(route('approvalWorkflows.index'));
    }

    /**
     * Display the specified ApprovalWorkflow.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $approvalWorkflow = $this->approvalWorkflowRepository->find($id);

        if (empty($approvalWorkflow)) {
            Flash::error('Approval Workflow not found');

            return redirect(route('approvalWorkflows.index'));
        }

        return view('approval_workflows.show')->with('approvalWorkflow', $approvalWorkflow);
    }

    /**
     * Show the form for editing the specified ApprovalWorkflow.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $approvalWorkflow = $this->approvalWorkflowRepository->find($id);

        if (empty($approvalWorkflow)) {
            Flash::error('Approval Workflow not found');

            return redirect(route('approvalWorkflows.index'));
        }

        return view('approval_workflows.edit')->with('approvalWorkflow', $approvalWorkflow);
    }

    /**
     * Update the specified ApprovalWorkflow in storage.
     *
     * @param  int              $id
     * @param UpdateApprovalWorkflowRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateApprovalWorkflowRequest $request)
    {
        $approvalWorkflow = $this->approvalWorkflowRepository->find($id);

        if (empty($approvalWorkflow)) {
            Flash::error('Approval Workflow not found');

            return redirect(route('approvalWorkflows.index'));
        }

        $approvalWorkflow = $this->approvalWorkflowRepository->update($request->all(), $id);

        Flash::success('Approval Workflow updated successfully.');

        return redirect(route('approvalWorkflows.index'));
    }

    /**
     * Remove the specified ApprovalWorkflow from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $approvalWorkflow = $this->approvalWorkflowRepository->find($id);

        if (empty($approvalWorkflow)) {
            Flash::error('Approval Workflow not found');

            return redirect(route('approvalWorkflows.index'));
        }

        $this->approvalWorkflowRepository->delete($id);

        Flash::success('Approval Workflow deleted successfully.');

        return redirect(route('approvalWorkflows.index'));
    }
}
