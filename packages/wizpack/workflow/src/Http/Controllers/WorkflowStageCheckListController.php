<?php

namespace WizPack\Workflow\Http\Controllers;

use WizPack\Workflow\DataTables\WorkflowStageCheckListDataTable;
use WizPack\Workflow\Http\Requests\CreateWorkflowStageCheckListRequest;
use WizPack\Workflow\Http\Requests\UpdateWorkflowStageCheckListRequest;
use WizPack\Workflow\Models\WorkflowStage;
use WizPack\Workflow\Repositories\WorkflowStageCheckListRepository;
use Exception;
use Illuminate\Auth\Access\Response;
use Laracasts\Flash\Flash;
use Prettus\Validator\Exceptions\ValidatorException;

class WorkflowStageCheckListController extends AppBaseController
{
    /** @var  WorkflowStageCheckListRepository */
    private $workflowStageCheckListRepository;
    private $workflowStages;

    public function __construct(
        WorkflowStageCheckListRepository $workflowStageCheckListRepo,
        WorkflowStage $workflowStages
    )
    {
        $this->workflowStageCheckListRepository = $workflowStageCheckListRepo;
        $this->workflowStages = $workflowStages;
        $this->middleware('auth');
    }

    /**
     * Display a listing of the WorkflowStageCheckList.
     *
     * @param WorkflowStageCheckListDataTable $workflowStageCheckListDataTable
     * @return Response
     */
    public function index(WorkflowStageCheckListDataTable $workflowStageCheckListDataTable)
    {
        return $workflowStageCheckListDataTable->render('wizpack::workflow_stage_check_lists.index');
    }

    /**
     * Show the form for creating a new WorkflowStageCheckList.
     *
     * @return Response
     */
    public function create()
    {
        return view('wizpack::workflow_stage_check_lists.create')
            ->withWorkflowStages($this->workflowStages->with(['workflowStageType'])->get()->pluck('workflowStageType.name','id'));
    }

    /**
     * Store a newly created WorkflowStageCheckList in storage.
     *
     * @param CreateWorkflowStageCheckListRequest $request
     *
     * @return Response
     * @throws ValidatorException
     */
    public function store(CreateWorkflowStageCheckListRequest $request)
    {
        $input = $request->all();

        $workflowStageCheckList = $this->workflowStageCheckListRepository->create($input);

        Flash::success('Workflow Stage Check List saved successfully.');

        return redirect(route('wizpack::workflowStageCheckLists.index'));
    }

    /**
     * Display the specified WorkflowStageCheckList.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $workflowStageCheckList = $this->workflowStageCheckListRepository->find($id);

        if (empty($workflowStageCheckList)) {
            Flash::error('Workflow Stage Check List not found');

            return redirect(route('wizpack::workflowStageCheckLists.index'));
        }

        return view('wizpack::workflow_stage_check_lists.show')->with('workflowStageCheckList', $workflowStageCheckList);
    }

    /**
     * Show the form for editing the specified WorkflowStageCheckList.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $workflowStageCheckList = $this->workflowStageCheckListRepository->find($id);

        if (empty($workflowStageCheckList)) {
            Flash::error('Workflow Stage Check List not found');

            return redirect(route('wizpack::workflowStageCheckLists.index'));
        }

        return view('wizpack::workflow_stage_check_lists.edit')
            ->with('workflowStageCheckList', $workflowStageCheckList)
            ->withWorkflowStages($this->workflowStages->with(['workflowStageType'])->get()->pluck('workflowStageType.name','id'));
    }

    /**
     * Update the specified WorkflowStageCheckList in storage.
     *
     * @param int $id
     * @param UpdateWorkflowStageCheckListRequest $request
     *
     * @return Response
     * @throws ValidatorException
     */
    public function update($id, UpdateWorkflowStageCheckListRequest $request)
    {
        $workflowStageCheckList = $this->workflowStageCheckListRepository->find($id);

        if (empty($workflowStageCheckList)) {
            Flash::error('Workflow Stage Check List not found');

            return redirect(route('wizpack::workflowStageCheckLists.index'));
        }

        $workflowStageCheckList = $this->workflowStageCheckListRepository->update($request->all(), $id);

        Flash::success('Workflow Stage Check List updated successfully.');

        return redirect(route('wizpack::workflowStageCheckLists.index'));
    }

    /**
     * Remove the specified WorkflowStageCheckList from storage.
     *
     * @param int $id
     *
     * @return Response
     * @throws Exception
     */
    public function destroy($id)
    {
        $workflowStageCheckList = $this->workflowStageCheckListRepository->find($id);

        if (empty($workflowStageCheckList)) {
            Flash::error('Workflow Stage Check List not found');

            return redirect(route('wizpack::workflowStageCheckLists.index'));
        }

        $this->workflowStageCheckListRepository->delete($id);

        Flash::success('Workflow Stage Check List deleted successfully.');

        return redirect(route('wizpack::workflowStageCheckLists.index'));
    }
}
