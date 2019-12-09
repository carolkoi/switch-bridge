<?php

namespace WizPack\Workflow\Http\Controllers\API;

use Illuminate\Http\Response;
use WizPack\Workflow\Http\Requests\API\CreateWorkflowStepAPIRequest;
use WizPack\Workflow\Http\Requests\API\UpdateWorkflowStepAPIRequest;
use WizPack\Workflow\Models\WorkflowStep;
use WizPack\Workflow\Repositories\API\WorkflowStepRepository;
use Illuminate\Http\Request;
use WizPack\Workflow\Http\Controllers\AppBaseController;

/**
 * Class WorkflowStepController
 * @package WizPack\Workflow\Http\Controllers\API
 */

class WorkflowStepAPIController extends AppBaseController
{
    /** @var  WorkflowStepRepository */
    private $workflowStepRepository;

    public function __construct(WorkflowStepRepository $workflowStepRepo)
    {
        $this->workflowStepRepository = $workflowStepRepo;
    }

    /**
     * @param Request $request
     * @return Response
     *
     * @SWG\Get(
     *      path="/workflowSteps",
     *      summary="Get a listing of the WorkflowSteps.",
     *      tags={"WorkflowStep"},
     *      description="Get all WorkflowSteps",
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
     *                  @SWG\Items(ref="#/definitions/WorkflowStep")
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
        $workflowSteps = $this->workflowStepRepository->all(
            $request->except(['skip', 'limit']),
            $request->get('skip'),
            $request->get('limit')
        );

        return $this->sendResponse($workflowSteps->toArray(), 'Workflow Steps retrieved successfully');
    }

    /**
     * @param CreateWorkflowStepAPIRequest $request
     * @return Response
     *
     * @SWG\Post(
     *      path="/workflowSteps",
     *      summary="Store a newly created WorkflowStep in storage",
     *      tags={"WorkflowStep"},
     *      description="Store WorkflowStep",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="body",
     *          in="body",
     *          description="WorkflowStep that should be stored",
     *          required=false,
     *          @SWG\Schema(ref="#/definitions/WorkflowStep")
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
     *                  ref="#/definitions/WorkflowStep"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function store(CreateWorkflowStepAPIRequest $request)
    {
        $input = $request->all();

        $workflowStep = $this->workflowStepRepository->create($input);

        return $this->sendResponse($workflowStep->toArray(), 'Workflow Step saved successfully');
    }

    /**
     * @param int $id
     * @return Response
     *
     * @SWG\Get(
     *      path="/workflowSteps/{id}",
     *      summary="Display the specified WorkflowStep",
     *      tags={"WorkflowStep"},
     *      description="Get WorkflowStep",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStep",
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
     *                  ref="#/definitions/WorkflowStep"
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
        /** @var WorkflowStep $workflowStep */
        $workflowStep = $this->workflowStepRepository->find($id);

        if (empty($workflowStep)) {
            return $this->sendError('Workflow Step not found');
        }

        return $this->sendResponse($workflowStep->toArray(), 'Workflow Step retrieved successfully');
    }

    /**
     * @param int $id
     * @param UpdateWorkflowStepAPIRequest $request
     * @return Response
     *
     * @SWG\Put(
     *      path="/workflowSteps/{id}",
     *      summary="Update the specified WorkflowStep in storage",
     *      tags={"WorkflowStep"},
     *      description="Update WorkflowStep",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStep",
     *          type="integer",
     *          required=true,
     *          in="path"
     *      ),
     *      @SWG\Parameter(
     *          name="body",
     *          in="body",
     *          description="WorkflowStep that should be updated",
     *          required=false,
     *          @SWG\Schema(ref="#/definitions/WorkflowStep")
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
     *                  ref="#/definitions/WorkflowStep"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function update($id, UpdateWorkflowStepAPIRequest $request)
    {
        $input = $request->all();

        /** @var WorkflowStep $workflowStep */
        $workflowStep = $this->workflowStepRepository->find($id);

        if (empty($workflowStep)) {
            return $this->sendError('Workflow Step not found');
        }

        $workflowStep = $this->workflowStepRepository->update($input, $id);

        return $this->sendResponse($workflowStep->toArray(), 'WorkflowStep updated successfully');
    }

    /**
     * @param int $id
     * @return Response
     *
     * @throws \Exception
     * @SWG\Delete(
     *      path="/workflowSteps/{id}",
     *      summary="Remove the specified WorkflowStep from storage",
     *      tags={"WorkflowStep"},
     *      description="Delete WorkflowStep",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of WorkflowStep",
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
        /** @var WorkflowStep $workflowStep */
        $workflowStep = $this->workflowStepRepository->find($id);

        if (empty($workflowStep)) {
            return $this->sendError('Workflow Step not found');
        }

        $workflowStep->delete();

        return $this->sendSuccess('Workflow Step deleted successfully');
    }
}
