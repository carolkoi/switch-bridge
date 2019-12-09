<?php

namespace WizPack\Workflow\Http\Controllers\API;

use Illuminate\Http\Response;
use WizPack\Workflow\Http\Requests\API\CreateWorkflowStageCheckListAPIRequest;
use WizPack\Workflow\Http\Requests\API\UpdateWorkflowStageCheckListAPIRequest;
use WizPack\Workflow\Models\WorkflowStageCheckList;
use WizPack\Workflow\Repositories\API\WorkflowStageCheckListRepository;
use Illuminate\Http\Request;
use WizPack\Workflow\Http\Controllers\AppBaseController;

/**
 * Class WorkflowStageCheckListController
 * @package WizPack\Workflow\Http\Controllers\API
 */

class WorkflowStageCheckListAPIController extends AppBaseController
{
    /** @var  WorkflowStageCheckListRepository */
    private $workflowStageCheckListRepository;

    public function __construct(WorkflowStageCheckListRepository $workflowStageCheckListRepo)
    {
        $this->workflowStageCheckListRepository = $workflowStageCheckListRepo;
    }

    /**
     * @param Request $request
     * @return Response
     *
     * @SWG\Get(
     *      path="/workflowStageCheckLists",
     *      summary="Get a listing of the WorkflowStageCheckLists.",
     *      tags={"WorkflowStageCheckList"},
     *      description="Get all WorkflowStageCheckLists",
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
     *                  @SWG\Items(ref="#/definitions/WorkflowStageCheckList")
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
        $workflowStageCheckLists = $this->workflowStageCheckListRepository->all(
            $request->except(['skip', 'limit']),
            $request->get('skip'),
            $request->get('limit')
        );

        return $this->sendResponse($workflowStageCheckLists->toArray(), 'Workflow Stage Check Lists retrieved successfully');
    }

    /**
     * @param CreateWorkflowStageCheckListAPIRequest $request
     * @return Response
     *
     * @SWG\Post(
     *      path="/workflowStageCheckLists",
     *      summary="Store a newly created WorkflowStageCheckList in storage",
     *      tags={"WorkflowStageCheckList"},
     *      description="Store WorkflowStageCheckList",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="body",
     *          in="body",
     *          description="WorkflowStageCheckList that should be stored",
     *          required=false,
     *          @SWG\Schema(ref="#/definitions/WorkflowStageCheckList")
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
     *                  ref="#/definitions/WorkflowStageCheckList"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function store(CreateWorkflowStageCheckListAPIRequest $request)
    {
        $input = $request->all();

        $workflowStageCheckList = $this->workflowStageCheckListRepository->create($input);

        return $this->sendResponse($workflowStageCheckList->toArray(), 'Workflow Stage Check List saved successfully');
    }

    /**
     * @param int $id
     * @return Response
     *
     * @SWG\Get(
     *      path="/workflowStageCheckLists/{id}",
     *      summary="Display the specified WorkflowStageCheckList",
     *      tags={"WorkflowStageCheckList"},
     *      description="Get WorkflowStageCheckList",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStageCheckList",
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
     *                  ref="#/definitions/WorkflowStageCheckList"
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
        /** @var WorkflowStageCheckList $workflowStageCheckList */
        $workflowStageCheckList = $this->workflowStageCheckListRepository->find($id);

        if (empty($workflowStageCheckList)) {
            return $this->sendError('Workflow Stage Check List not found');
        }

        return $this->sendResponse($workflowStageCheckList->toArray(), 'Workflow Stage Check List retrieved successfully');
    }

    /**
     * @param int $id
     * @param UpdateWorkflowStageCheckListAPIRequest $request
     * @return Response
     *
     * @SWG\Put(
     *      path="/workflowStageCheckLists/{id}",
     *      summary="Update the specified WorkflowStageCheckList in storage",
     *      tags={"WorkflowStageCheckList"},
     *      description="Update WorkflowStageCheckList",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStageCheckList",
     *          type="integer",
     *          required=true,
     *          in="path"
     *      ),
     *      @SWG\Parameter(
     *          name="body",
     *          in="body",
     *          description="WorkflowStageCheckList that should be updated",
     *          required=false,
     *          @SWG\Schema(ref="#/definitions/WorkflowStageCheckList")
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
     *                  ref="#/definitions/WorkflowStageCheckList"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function update($id, UpdateWorkflowStageCheckListAPIRequest $request)
    {
        $input = $request->all();

        /** @var WorkflowStageCheckList $workflowStageCheckList */
        $workflowStageCheckList = $this->workflowStageCheckListRepository->find($id);

        if (empty($workflowStageCheckList)) {
            return $this->sendError('Workflow Stage Check List not found');
        }

        $workflowStageCheckList = $this->workflowStageCheckListRepository->update($input, $id);

        return $this->sendResponse($workflowStageCheckList->toArray(), 'WorkflowStageCheckList updated successfully');
    }

    /**
     * @param int $id
     * @return Response
     *
     * @throws \Exception
     * @SWG\Delete(
     *      path="/workflowStageCheckLists/{id}",
     *      summary="Remove the specified WorkflowStageCheckList from storage",
     *      tags={"WorkflowStageCheckList"},
     *      description="Delete WorkflowStageCheckList",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStageCheckList",
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
        /** @var WorkflowStageCheckList $workflowStageCheckList */
        $workflowStageCheckList = $this->workflowStageCheckListRepository->find($id);

        if (empty($workflowStageCheckList)) {
            return $this->sendError('Workflow Stage Check List not found');
        }

        $workflowStageCheckList->delete();

        return $this->sendSuccess('Workflow Stage Check List deleted successfully');
    }
}
