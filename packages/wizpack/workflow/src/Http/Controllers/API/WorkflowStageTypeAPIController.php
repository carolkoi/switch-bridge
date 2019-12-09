<?php

namespace WizPack\Workflow\Http\Controllers\API;

use Illuminate\Http\Response;
use WizPack\Workflow\Http\Requests\API\CreateWorkflowStageTypeAPIRequest;
use WizPack\Workflow\Http\Requests\API\UpdateWorkflowStageTypeAPIRequest;
use WizPack\Workflow\Models\WorkflowStageType;
use WizPack\Workflow\Repositories\API\WorkflowStageTypeRepository;
use Illuminate\Http\Request;
use WizPack\Workflow\Http\Controllers\AppBaseController;

/**
 * Class WorkflowStageTypeController
 * @package WizPack\Workflow\Http\Controllers\API
 */

class WorkflowStageTypeAPIController extends AppBaseController
{
    /** @var  WorkflowStageTypeRepository */
    private $workflowStageTypeRepository;

    public function __construct(WorkflowStageTypeRepository $workflowStageTypeRepo)
    {
        $this->workflowStageTypeRepository = $workflowStageTypeRepo;
    }

    /**
     * @param Request $request
     * @return Response
     *
     * @SWG\Get(
     *      path="/workflowStageTypes",
     *      summary="Get a listing of the WorkflowStageTypes.",
     *      tags={"WorkflowStageType"},
     *      description="Get all WorkflowStageTypes",
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
     *                  @SWG\Items(ref="#/definitions/WorkflowStageType")
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
        $workflowStageTypes = $this->workflowStageTypeRepository->all(
            $request->except(['skip', 'limit']),
            $request->get('skip'),
            $request->get('limit')
        );

        return $this->sendResponse($workflowStageTypes->toArray(), 'Workflow Stage Types retrieved successfully');
    }

    /**
     * @param CreateWorkflowStageTypeAPIRequest $request
     * @return Response
     *
     * @SWG\Post(
     *      path="/workflowStageTypes",
     *      summary="Store a newly created WorkflowStageType in storage",
     *      tags={"WorkflowStageType"},
     *      description="Store WorkflowStageType",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="body",
     *          in="body",
     *          description="WorkflowStageType that should be stored",
     *          required=false,
     *          @SWG\Schema(ref="#/definitions/WorkflowStageType")
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
     *                  ref="#/definitions/WorkflowStageType"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function store(CreateWorkflowStageTypeAPIRequest $request)
    {
        $input = $request->all();

        $workflowStageType = $this->workflowStageTypeRepository->create($input);

        return $this->sendResponse($workflowStageType->toArray(), 'Workflow Stage Type saved successfully');
    }

    /**
     * @param int $id
     * @return Response
     *
     * @SWG\Get(
     *      path="/workflowStageTypes/{id}",
     *      summary="Display the specified WorkflowStageType",
     *      tags={"WorkflowStageType"},
     *      description="Get WorkflowStageType",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStageType",
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
     *                  ref="#/definitions/WorkflowStageType"
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
        /** @var WorkflowStageType $workflowStageType */
        $workflowStageType = $this->workflowStageTypeRepository->find($id);

        if (empty($workflowStageType)) {
            return $this->sendError('Workflow Stage Type not found');
        }

        return $this->sendResponse($workflowStageType->toArray(), 'Workflow Stage Type retrieved successfully');
    }

    /**
     * @param int $id
     * @param UpdateWorkflowStageTypeAPIRequest $request
     * @return Response
     *
     * @SWG\Put(
     *      path="/workflowStageTypes/{id}",
     *      summary="Update the specified WorkflowStageType in storage",
     *      tags={"WorkflowStageType"},
     *      description="Update WorkflowStageType",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStageType",
     *          type="integer",
     *          required=true,
     *          in="path"
     *      ),
     *      @SWG\Parameter(
     *          name="body",
     *          in="body",
     *          description="WorkflowStageType that should be updated",
     *          required=false,
     *          @SWG\Schema(ref="#/definitions/WorkflowStageType")
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
     *                  ref="#/definitions/WorkflowStageType"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function update($id, UpdateWorkflowStageTypeAPIRequest $request)
    {
        $input = $request->all();

        /** @var WorkflowStageType $workflowStageType */
        $workflowStageType = $this->workflowStageTypeRepository->find($id);

        if (empty($workflowStageType)) {
            return $this->sendError('Workflow Stage Type not found');
        }

        $workflowStageType = $this->workflowStageTypeRepository->update($input, $id);

        return $this->sendResponse($workflowStageType->toArray(), 'WorkflowStageType updated successfully');
    }

    /**
     * @param int $id
     * @return Response
     *
     * @SWG\Delete(
     *      path="/workflowStageTypes/{id}",
     *      summary="Remove the specified WorkflowStageType from storage",
     *      tags={"WorkflowStageType"},
     *      description="Delete WorkflowStageType",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStageType",
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
        /** @var WorkflowStageType $workflowStageType */
        $workflowStageType = $this->workflowStageTypeRepository->find($id);

        if (empty($workflowStageType)) {
            return $this->sendError('Workflow Stage Type not found');
        }

        $workflowStageType->delete();

        return $this->sendSuccess('Workflow Stage Type deleted successfully');
    }
}
