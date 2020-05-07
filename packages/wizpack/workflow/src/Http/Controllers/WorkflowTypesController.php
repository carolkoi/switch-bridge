<?php

namespace WizPack\Workflow\Http\Controllers;

use WizPack\Workflow\DataTables\WorkflowTypesDataTable;
use WizPack\Workflow\Http\Requests\CreateWorkflowTypesRequest;
use WizPack\Workflow\Http\Requests\UpdateWorkflowTypesRequest;
use WizPack\Workflow\Models\WorkflowType;
use WizPack\Workflow\Repositories\WorkflowStagesRepository;
use WizPack\Workflow\Repositories\WorkflowTypesRepository;
use Exception;
use Illuminate\Support\Facades\Response;
use Laracasts\Flash\Flash;
use Prettus\Validator\Exceptions\ValidatorException;
use Illuminate\Http\Request;
use Illuminate\Support\Str;


class WorkflowTypesController extends AppBaseController
{
    /** @var  WorkflowTypesRepository */
    private $workflowTypesRepository;
    private $stagesRepository;

    public function __construct(WorkflowTypesRepository $workflowTypesRepo, WorkflowStagesRepository $stagesRepository)
    {
        $this->workflowTypesRepository = $workflowTypesRepo;
        $this->stagesRepository = $stagesRepository;
        $this->middleware('auth');
    }

    /**
     * Display a listing of the WorkflowTypes.
     *
     * @param WorkflowTypesDataTable $workflowTypesDataTable
     * @return Response
     */
    public function index(WorkflowTypesDataTable $workflowTypesDataTable)
    {
        return $workflowTypesDataTable->render('wizpack::workflow_types.index');
    }

    /**
     * Show the form for creating a new WorkflowTypes.
     *
     * @return Response
     */
    public function create()
    {
        return view('wizpack::workflow_types.create');
    }

    /**
     * Store a newly created WorkflowTypes in storage.
     *
     * @param CreateWorkflowTypesRequest $request
     *
     * @return Response
     * @throws ValidatorException
     */
    public function store(CreateWorkflowTypesRequest $request)
    {
        $input = $request->all();
        $input['slug'] = Str::lower(str_replace(' ', '_', $request->get('name')));

        if (WorkflowType::where('slug', '=', $input['slug'] )->exists()) {
            Flash::error('Approval Type with the same slug already exist');
            return redirect(route('upesi::approval-types.index'));

        }else
        $workflowTypes = $this->workflowTypesRepository->create($input);

        Flash::success('Approval Type saved successfully.');

        return redirect(route('upesi::approval-types.index'));
    }

    /**
     * Display the specified WorkflowTypes.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $workflowTypes = $this->workflowTypesRepository->find($id);

        if (empty($workflowTypes)) {
            Flash::error('Approval Type not found');

            return redirect(route('upesi::approval-types.index'));
        }

        return view('wizpack::workflow_types.show')->with('workflowTypes', $workflowTypes);
    }

    /**
     * Show the form for editing the specified WorkflowTypes.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {

        $workflowTypes = $this->workflowTypesRepository->find($id);

        if (empty($workflowTypes)) {
            Flash::error('Approval Type not found');

            return redirect(route('upesi::approval-types.index'));
        }

        return view('wizpack::workflow_types.edit')->with('workflowTypes', $workflowTypes);
    }

    /**
     * Update the specified WorkflowTypes in storage.
     *
     * @param int $id
     * @param UpdateWorkflowTypesRequest $request
     *
     * @return Response
     * @throws ValidatorException
     */
    public function update($id, Request $request)
    {
        $workflowTypes = $this->workflowTypesRepository->find($id);
        $input = $request->all();
        $input['slug'] = Str::lower(str_replace(' ', '_', $request->get('name')));

        if (empty($workflowTypes)) {
            Flash::error('Approval Type not found');

            return redirect(route('upesi::approval-types.index'));
        }
        if (WorkflowType::where('slug', '=', $input['slug'] )->exists()) {
            Flash::error('Approval Type with the same slug already exist');
            return redirect(route('upesi::approval-types.index'));

        }else
        $workflowTypes = $this->workflowTypesRepository->update($input, $id);

        Flash::success('Approval Type updated successfully.');

        return redirect(route('upesi::approval-types.index'));
    }

    /**
     * Remove the specified WorkflowTypes from storage.
     *
     * @param int $id
     *
     * @return Response
     * @throws Exception
     */
    public function destroy($id)
    {
        $checkIfStageIsAttached = $this->stagesRepository->count(['workflow_type_id'=>$id]);

        if($checkIfStageIsAttached>0){
            Flash::error('Approval Type Cannot be deleted, there is a workflow stages attached to this workflow type');
            return redirect()->back();
        }

        $workflowTypes = $this->workflowTypesRepository->find($id);

        if (empty($workflowTypes)) {
            Flash::error('Workflow Types not found');

            return redirect(route('upesi::approval-types.index'));
        }

        $this->workflowTypesRepository->delete($id);

        Flash::success('Approval Type deleted successfully.');

        return redirect(route('upesi::approval-types.index'));
    }
}
