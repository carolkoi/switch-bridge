<?php

namespace WizPack\Workflow\Http\Controllers;

use WizPack\Workflow\DataTables\WorkflowStagesDataTable;
use WizPack\Workflow\Http\Requests\CreateWorkflowStagesRequest;
use WizPack\Workflow\Http\Requests\UpdateWorkflowStagesRequest;
use WizPack\Workflow\Models\WorkflowStage;
use WizPack\Workflow\Repositories\WorkflowStagesRepository;
use WizPack\Workflow\Repositories\WorkflowStageTypesRepository;
use WizPack\Workflow\Repositories\WorkflowStepRepository;
use WizPack\Workflow\Repositories\WorkflowTypesRepository;
use Illuminate\Support\Facades\Response;
use Laracasts\Flash\Flash;
use Prettus\Validator\Exceptions\ValidatorException;


class WorkflowStagesController extends AppBaseController
{
    /** @var  WorkflowStagesRepository */
    private $workflowStagesRepository;
    private $workflowTypesRepository;
    private $stageTypesRepository;
    private $workflowStepRepository;

    public function __construct(
        WorkflowStagesRepository $workflowStagesRepo,
        WorkflowStageTypesRepository $stageTypesRepository,
        WorkflowTypesRepository $workflowTypesRepository,
        WorkflowStepRepository $workflowStepRepository
    )
    {
        $this->workflowStagesRepository = $workflowStagesRepo;
        $this->stageTypesRepository = $stageTypesRepository;
        $this->workflowTypesRepository = $workflowTypesRepository;
        $this->workflowStepRepository = $workflowStepRepository;
        $this->middleware('auth');
    }

    /**
     * Display a listing of the WorkflowStages.
     *
     * @param WorkflowStagesDataTable $workflowStagesDataTable
     * @return Response
     */
    public function index(WorkflowStagesDataTable $workflowStagesDataTable)
    {
        return $workflowStagesDataTable->render('wizpack::workflow_stages.index');
    }

    /**
     * Show the form for creating a new WorkflowStages.
     *
     * @return Response
     */
    public function create()
    {
        return view('wizpack::workflow_stages.create')
            ->withWorkFlowTypes($this->workflowTypesRepository->all(['name','id'])->pluck('name', 'id'))
            ->withWorkFlowStageTypes($this->stageTypesRepository->all(['name','id'])->pluck('name', 'id'));
    }

    /**
     * Store a newly created WorkflowStages in storage.
     *
     * @param CreateWorkflowStagesRequest $request
     *
     * @return Response
     * @throws ValidatorException
     */
    public function store(CreateWorkflowStagesRequest $request)
    {
        $input = $request->all();
//        $input['workflow_type_id'] = $request->get('workflow_type_id');
//        if (WorkflowStage::where('id', '=', $input['workflow_type_id'] )->exists()) {
//            Flash::error('Approval Stage Partner already exist');
//            return redirect(route('upesi::approval-stages.index'));
//
//        }else

        $workflowStages = $this->workflowStagesRepository->create($input);

        Flash::success('Approval Stage saved successfully.');

        return redirect(route('upesi::approval-stages.index'));
    }

    /**
     * Display the specified WorkflowStages.
     *
     * @param int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $workflowStages = $this->workflowStagesRepository->find($id);

        if (empty($workflowStages)) {
            Flash::error('Approval Stage not found');

            return redirect(route('upesi::approval-stages.index'));
        }

        return view('wizpack::workflow_stages.show')
            ->withWorkflowStages($workflowStages)
            ->withWorkFlowTypes($this->workflowTypesRepository->all(['name','id'])->pluck('name', 'id'))
            ->withWorkFlowStageTypes($this->stageTypesRepository->all(['name','id'])->pluck('name', 'id'));
    }

    /**
     * Show the form for editing the specified WorkflowStages.
     *
     * @param int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $workflowStages = $this->workflowStagesRepository->find($id);

        if (empty($workflowStages)) {
            Flash::error('Approval Stage not found');

            return redirect(route('upesi::approval-stages.index'));
        }

        return view('wizpack::workflow_stages.edit')->with('workflowStages', $workflowStages)
            ->withWorkFlowTypes($this->workflowTypesRepository->all(['name','id'])->pluck('name', 'id'))
            ->withWorkFlowStageTypes($this->stageTypesRepository->all(['name','id'])->pluck('name', 'id'));
    }

    /**
     * Update the specified WorkflowStages in storage.
     *
     * @param int $id
     * @param UpdateWorkflowStagesRequest $request
     *
     * @return Response
     * @throws ValidatorException
     */
    public function update($id, UpdateWorkflowStagesRequest $request)
    {
        $workflowStages = $this->workflowStagesRepository->find($id);

        if (empty($workflowStages)) {
            Flash::error('Approval Stage not found');

            return redirect(route('upesi::approval-stages.index'));
        }

        $workflowStages = $this->workflowStagesRepository->update($request->all(), $id);

        Flash::success('Approval Stage updated successfully.');

        return redirect(route('upesi::approval-stages.index'));
    }

    /**
     * Remove the specified WorkflowStages from storage.
     *
     * @param int $id
     *
     * @return Response
     * @throws \Exception
     */
    public function destroy($id)
    {
        $checkIfStepIsAttached = $this->workflowStepRepository->count(['workflow_stage_id' => $id]);

        if ($checkIfStepIsAttached > 0) {
            Flash::error('Approval Stage Cannot be deleted, there is an approval step attached to this partner stage ');
            return redirect()->back();
        }

        $workflowStages = $this->workflowStagesRepository->find($id);

        if (empty($workflowStages)) {
            Flash::error('Approval Stage not found');

            return redirect(route('upesi::approval-stages.index'));
        }

        $this->workflowStagesRepository->delete($id);

        Flash::success('Approval Stage deleted successfully.');

        return redirect(route('upesi::approval-stages.index'));
    }
}
