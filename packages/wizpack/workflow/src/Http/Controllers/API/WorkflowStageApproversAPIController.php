<?php

namespace WizPack\Workflow\Http\Controllers\API;

use Illuminate\Http\Response;
use WizPack\Workflow\Http\Requests\API\CreateWorkflowStageApproversAPIRequest;
use WizPack\Workflow\Http\Requests\API\UpdateWorkflowStageApproversAPIRequest;
use WizPack\Workflow\Models\WorkflowStageApprovers;
use WizPack\Workflow\Repositories\API\WorkflowStageApproversRepository;
use Illuminate\Http\Request;
use WizPack\Workflow\Http\Controllers\AppBaseController;

/**
 * Class WorkflowStageApproversController
 * @package WizPack\Workflow\Http\Controllers\API
 */

class WorkflowStageApproversAPIController extends AppBaseController
{
    /** @var  WorkflowStageApproversRepository */
    private $workflowStageApproversRepository;

    public function __construct(WorkflowStageApproversRepository $workflowStageApproversRepo)
    {
        $this->workflowStageApproversRepository = $workflowStageApproversRepo;
    }

    /**
     * @param Request $request
     * @return Response
     *
     * @SWG\Get(
     *      path="/workflowStageApprovers",
     *      summary="Get a listing of the WorkflowStageApprovers.",
     *      tags={"WorkflowStageApprovers"},
     *      description="Get all WorkflowStageApprovers",
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
     *                  @SWG\Items(ref="#/definitions/WorkflowStageApprovers")
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
        $workflowStageApprovers = $this->workflowStageApproversRepository->all(
            $request->except(['skip', 'limit']),
            $request->get('skip'),
            $request->get('limit')
        );

        return $this->sendResponse($workflowStageApprovers->toArray(), 'Workflow Stage Approvers retrieved successfully');
    }

    /**
     * @param CreateWorkflowStageApproversAPIRequest $request
     * @return Response
     *
     * @SWG\Post(
     *      path="/workflowStageApprovers",
     *      summary="Store a newly created WorkflowStageApprovers in storage",
     *      tags={"WorkflowStageApprovers"},
     *      description="Store WorkflowStageApprovers",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="body",
     *          in="body",
     *          description="WorkflowStageApprovers that should be stored",
     *          required=false,
     *          @SWG\Schema(ref="#/definitions/WorkflowStageApprovers")
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
     *                  ref="#/definitions/WorkflowStageApprovers"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function store(CreateWorkflowStageApproversAPIRequest $request)
    {
        $input = $request->all();

        $workflowStageApprovers = $this->workflowStageApproversRepository->create($input);

        return $this->sendResponse($workflowStageApprovers->toArray(), 'Workflow Stage Approvers saved successfully');
    }

    /**
     * @param int $id
     * @return Response
     *
     * @SWG\Get(
     *      path="/workflowStageApprovers/{id}",
     *      summary="Display the specified WorkflowStageApprovers",
     *      tags={"WorkflowStageApprovers"},
     *      description="Get WorkflowStageApprovers",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStageApprovers",
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
     *                  ref="#/definitions/WorkflowStageApprovers"
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
        /** @var WorkflowStageApprovers $workflowStageApprovers */
        $workflowStageApprovers = $this->workflowStageApproversRepository->find($id);

        if (empty($workflowStageApprovers)) {
            return $this->sendError('Workflow Stage Approvers not found');
        }

        return $this->sendResponse($workflowStageApprovers->toArray(), 'Workflow Stage Approvers retrieved successfully');
    }

    /**
     * @param int $id
     * @param UpdateWorkflowStageApproversAPIRequest $request
     * @return Response
     *
     * @SWG\Put(
     *      path="/workflowStageApprovers/{id}",
     *      summary="Update the specified WorkflowStageApprovers in storage",
     *      tags={"WorkflowStageApprovers"},
     *      description="Update WorkflowStageApprovers",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStageApprovers",
     *          type="integer",
     *          required=true,
     *          in="path"
     *      ),
     *      @SWG\Parameter(
     *          name="body",
     *          in="body",
     *          description="WorkflowStageApprovers that should be updated",
     *          required=false,
     *          @SWG\Schema(ref="#/definitions/WorkflowStageApprovers")
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
     *                  ref="#/definitions/WorkflowStageApprovers"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function update($id, UpdateWorkflowStageApproversAPIRequest $request)
    {
        $input = $request->all();

        /** @var WorkflowStageApprovers $workflowStageApprovers */
        $workflowStageApprovers = $this->workflowStageApproversRepository->find($id);

        if (empty($workflowStageApprovers)) {
            return $this->sendError('Workflow Stage Approvers not found');
        }

        $workflowStageApprovers = $this->workflowStageApproversRepository->update($input, $id);

        return $this->sendResponse($workflowStageApprovers->toArray(), 'WorkflowStageApprovers updated successfully');
    }

    /**
     * @param int $id
     * @return Response
     *
     * @throws \Exception
     * @SWG\Delete(
     *      path="/workflowStageApprovers/{id}",
     *      summary="Remove the specified WorkflowStageApprovers from storage",
     *      tags={"WorkflowStageApprovers"},
     *      description="Delete WorkflowStageApprovers",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStageApprovers",
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
        /** @var WorkflowStageApprovers $workflowStageApprovers */
        $workflowStageApprovers = $this->workflowStageApproversRepository->find($id);

        if (empty($workflowStageApprovers)) {
            return $this->sendError('Workflow Stage Approvers not found');
        }

        $workflowStageApprovers->delete();

        return $this->sendSuccess('Workflow Stage Approvers deleted successfully');
    }
}
