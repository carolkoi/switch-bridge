<?php

namespace WizPack\Workflow\Http\Controllers\API;

use Illuminate\Http\Response;
use WizPack\Workflow\Http\Requests\API\CreateWorkflowStepChecklistAPIRequest;
use WizPack\Workflow\Http\Requests\API\UpdateWorkflowStepChecklistAPIRequest;
use WizPack\Workflow\Models\WorkflowStepCheckList;
use WizPack\Workflow\Repositories\API\WorkflowStepChecklistRepository;
use Illuminate\Http\Request;
use WizPack\Workflow\Http\Controllers\AppBaseController;


/**
 * Class WorkflowStepChecklistController
 * @package WizPack\Workflow\Http\Controllers\API
 */

class WorkflowStepChecklistAPIController extends AppBaseController
{
    /** @var  WorkflowStepChecklistRepository */
    private $workflowStepChecklistRepository;

    public function __construct(WorkflowStepChecklistRepository $workflowStepChecklistRepo)
    {
        $this->workflowStepChecklistRepository = $workflowStepChecklistRepo;
    }

    /**
     * @param Request $request
     * @return Response
     *
     * @SWG\Get(
     *      path="/workflowStepChecklists",
     *      summary="Get a listing of the WorkflowStepChecklists.",
     *      tags={"WorkflowStepChecklist"},
     *      description="Get all WorkflowStepChecklists",
     *      produces={"application/json"},
     *      @SWG\Response(
     *          response=200,
     *          description="successful operation",
     *          @SWG\Schema(
     *              type="object",
     *              @SWG\Property(
     *                  property="success",
     *                  type="boolean"
     *              ),
     *              @SWG\Property(
     *                  property="data",
     *                  type="array",
     *                  @SWG\Items(ref="#/definitions/WorkflowStepChecklist")
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function index(Request $request)
    {
        $workflowStepChecklists = $this->workflowStepChecklistRepository->all(
            $request->except(['skip', 'limit']),
            $request->get('skip'),
            $request->get('limit')
        );

        return $this->sendResponse($workflowStepChecklists->toArray(), 'Workflow Step Checklists retrieved successfully');
    }

    /**
     * @param CreateWorkflowStepChecklistAPIRequest $request
     * @return Response
     *
     * @SWG\Post(
     *      path="/workflowStepChecklists",
     *      summary="Store a newly created WorkflowStepChecklist in storage",
     *      tags={"WorkflowStepChecklist"},
     *      description="Store WorkflowStepChecklist",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="body",
     *          in="body",
     *          description="WorkflowStepChecklist that should be stored",
     *          required=false,
     *          @SWG\Schema(ref="#/definitions/WorkflowStepChecklist")
     *      ),
     *      @SWG\Response(
     *          response=200,
     *          description="successful operation",
     *          @SWG\Schema(
     *              type="object",
     *              @SWG\Property(
     *                  property="success",
     *                  type="boolean"
     *              ),
     *              @SWG\Property(
     *                  property="data",
     *                  ref="#/definitions/WorkflowStepChecklist"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function store(CreateWorkflowStepChecklistAPIRequest $request)
    {
        $input = $request->all();

        $workflowStepChecklist = $this->workflowStepChecklistRepository->create($input);

        return $this->sendResponse($workflowStepChecklist->toArray(), 'Workflow Step Checklist saved successfully');
    }

    /**
     * @param int $id
     * @return Response
     *
     * @SWG\Get(
     *      path="/workflowStepChecklists/{id}",
     *      summary="Display the specified WorkflowStepChecklist",
     *      tags={"WorkflowStepChecklist"},
     *      description="Get WorkflowStepChecklist",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStepChecklist",
     *          type="integer",
     *          required=true,
     *          in="path"
     *      ),
     *      @SWG\Response(
     *          response=200,
     *          description="successful operation",
     *          @SWG\Schema(
     *              type="object",
     *              @SWG\Property(
     *                  property="success",
     *                  type="boolean"
     *              ),
     *              @SWG\Property(
     *                  property="data",
     *                  ref="#/definitions/WorkflowStepChecklist"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function show($id)
    {
        /** @var WorkflowStepChecklist $workflowStepChecklist */
        $workflowStepChecklist = $this->workflowStepChecklistRepository->find($id);

        if (empty($workflowStepChecklist)) {
            return $this->sendError('Workflow Step Checklist not found');
        }

        return $this->sendResponse($workflowStepChecklist->toArray(), 'Workflow Step Checklist retrieved successfully');
    }

    /**
     * @param int $id
     * @param UpdateWorkflowStepChecklistAPIRequest $request
     * @return Response
     *
     * @SWG\Put(
     *      path="/workflowStepChecklists/{id}",
     *      summary="Update the specified WorkflowStepChecklist in storage",
     *      tags={"WorkflowStepChecklist"},
     *      description="Update WorkflowStepChecklist",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStepChecklist",
     *          type="integer",
     *          required=true,
     *          in="path"
     *      ),
     *      @SWG\Parameter(
     *          name="body",
     *          in="body",
     *          description="WorkflowStepChecklist that should be updated",
     *          required=false,
     *          @SWG\Schema(ref="#/definitions/WorkflowStepChecklist")
     *      ),
     *      @SWG\Response(
     *          response=200,
     *          description="successful operation",
     *          @SWG\Schema(
     *              type="object",
     *              @SWG\Property(
     *                  property="success",
     *                  type="boolean"
     *              ),
     *              @SWG\Property(
     *                  property="data",
     *                  ref="#/definitions/WorkflowStepChecklist"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function update($id, UpdateWorkflowStepChecklistAPIRequest $request)
    {
        $input = $request->all();

        /** @var WorkflowStepChecklist $workflowStepChecklist */
        $workflowStepChecklist = $this->workflowStepChecklistRepository->find($id);

        if (empty($workflowStepChecklist)) {
            return $this->sendError('Workflow Step Checklist not found');
        }

        $workflowStepChecklist = $this->workflowStepChecklistRepository->update($input, $id);

        return $this->sendResponse($workflowStepChecklist->toArray(), 'WorkflowStepChecklist updated successfully');
    }

    /**
     * @param int $id
     * @return Response
     *
     * @throws \Exception
     * @SWG\Delete(
     *      path="/workflowStepChecklists/{id}",
     *      summary="Remove the specified WorkflowStepChecklist from storage",
     *      tags={"WorkflowStepChecklist"},
     *      description="Delete WorkflowStepChecklist",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStepChecklist",
     *          type="integer",
     *          required=true,
     *          in="path"
     *      ),
     *      @SWG\Response(
     *          response=200,
     *          description="successful operation",
     *          @SWG\Schema(
     *              type="object",
     *              @SWG\Property(
     *                  property="success",
     *                  type="boolean"
     *              ),
     *              @SWG\Property(
     *                  property="data",
     *                  type="string"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function destroy($id)
    {
        /** @var WorkflowStepChecklist $workflowStepChecklist */
        $workflowStepChecklist = $this->workflowStepChecklistRepository->find($id);

        if (empty($workflowStepChecklist)) {
            return $this->sendError('Workflow Step Checklist not found');
        }

        $workflowStepChecklist->delete();

        return $this->sendSuccess('Workflow Step Checklist deleted successfully');
    }
}
