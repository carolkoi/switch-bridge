<?php

namespace WizPack\Workflow\Http\Controllers;

use Illuminate\Support\Str;
use WizPack\Workflow\DataTables\WorkflowStageTypesDataTable;
use WizPack\Workflow\Http\Requests\CreateWorkflowStageTypesRequest;
use WizPack\Workflow\Http\Requests\UpdateWorkflowStageTypesRequest;
use WizPack\Workflow\Models\WorkflowStageType;
use WizPack\Workflow\Repositories\WorkflowStagesRepository;
use WizPack\Workflow\Repositories\WorkflowStageTypesRepository;
use Exception;
use Illuminate\Support\Facades\Response;
use Laracasts\Flash\Flash;
use Prettus\Validator\Exceptions\ValidatorException;
use Illuminate\http\Request;


class WorkflowStageTypesController extends AppBaseController
{
    /** @var  WorkflowStageTypesRepository */
    private $workflowStageTypesRepository;
    private $stagesRepository;

    public function __construct(WorkflowStageTypesRepository $workflowStageTypesRepo, WorkflowStagesRepository $stagesRepository)
    {
        $this->workflowStageTypesRepository = $workflowStageTypesRepo;
        $this->stagesRepository = $stagesRepository;
        $this->middleware('auth');
    }

    /**
     * Display a listing of the WorkflowStageTypes.
     *
     * @param WorkflowStageTypesDataTable $workflowStageTypesDataTable
     * @return Response
     */
    public function index(WorkflowStageTypesDataTable $workflowStageTypesDataTable)
    {
        return $workflowStageTypesDataTable->render('wizpack::workflow_stage_types.index');
    }

    /**
     * Show the form for creating a new WorkflowStageTypes.
     *
     * @return Response
     */
    public function create()
    {
        return view('wizpack::workflow_stage_types.create');
    }

    /**
     * Store a newly created WorkflowStageTypes in storage.
     *
     * @param CreateWorkflowStageTypesRequest $request
     *
     * @return Response
     * @throws ValidatorException
     */
    public function store(CreateWorkflowStageTypesRequest $request)
    {
        $input = $request->all();
        $input['slug'] = Str::lower(str_replace(' ', '_', $request->get('name')));
//        dd($input);

        if (WorkflowStageType::where('slug', '=', $input['slug'] )->exists()) {
            Flash::error('Approval Stage Partner with the same Slug already exist');
            return redirect(route('upesi::approval-partners.index'));

        }else
        $workflowStageTypes = $this->workflowStageTypesRepository->create($input);

        Flash::success('Approval Stage Partner saved successfully.');

        return redirect(route('upesi::approval-partners.index'));
    }

    /**
     * Display the specified WorkflowStageTypes.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $workflowStageTypes = $this->workflowStageTypesRepository->find($id);

        if (empty($workflowStageTypes)) {
            Flash::error('Approval Stage Partner Types not found');

            return redirect(route('upesi::approval-partners.index'));
        }

        return view('wizpack::workflow_stage_types.show')->with('workflowStageTypes', $workflowStageTypes);
    }

    /**
     * Show the form for editing the specified WorkflowStageTypes.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $workflowStageTypes = $this->workflowStageTypesRepository->find($id);

        if (empty($workflowStageTypes)) {
            Flash::error('Workflow Stage Types not found');

            return redirect(route('upesi::approval-partners.index'));
        }

        return view('wizpack::workflow_stage_types.edit')->with('workflowStageTypes', $workflowStageTypes);
    }

    /**
     * Update the specified WorkflowStageTypes in storage.
     *
     * @param int $id
     * @param UpdateWorkflowStageTypesRequest $request
     *
     * @return Response
     * @throws ValidatorException
     */
    public function update($id, Request $request)
    {
        $workflowStageTypes = $this->workflowStageTypesRepository->find($id);
        $input = $request->all();
        $input['slug'] = Str::lower(str_replace(' ', '_', $request->get('name')));

        if (empty($workflowStageTypes)) {
            Flash::error('Approval Stage Partner not found');

            return redirect(route('wizpack::workflowStageTypes.index'));
        }
//        if (WorkflowStageType::where('slug', '=', $input['slug'] )->exists()) {
//            Flash::error('Approval Stage Partner with the same Slug already exist');
//
//            return redirect(route('upesi::approval-partners.index'));
//
//        }else

        $workflowStageTypes = $this->workflowStageTypesRepository->update($input, $id);

        Flash::success('Approval Stage Partner updated successfully.');

        return redirect(route('upesi::approval-partners.index'));
    }

    /**
     * Remove the specified WorkflowStageTypes from storage.
     *
     * @param int $id
     *
     * @return Response
     * @throws Exception
     */
    public function destroy($id)
    {
        $checkIfStageIsAttached = $this->stagesRepository->count(['workflow_stage_type_id'=>$id]);

        if($checkIfStageIsAttached>0){
            Flash::error('Approval Stage Partner Cannot be deleted, there is a transaction approval attached to this Approval Stage Partner');
            return redirect()->back();
        }

        $workflowStageTypes = $this->workflowStageTypesRepository->find($id);

        if (empty($workflowStageTypes)) {
            Flash::error('Approval Stage Partner not found');

            return redirect(route('upesi::approval-partners.index'));
        }

        $this->workflowStageTypesRepository->delete($id);

        Flash::success('Approval Stage Partner deleted successfully.');

        return redirect(route('upesi::approval-partners.index'));
    }
}
