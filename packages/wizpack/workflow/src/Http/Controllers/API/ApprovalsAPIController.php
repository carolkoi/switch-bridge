<?php

namespace WizPack\Workflow\Http\Controllers\API;

use Illuminate\Http\Response;
use WizPack\Workflow\Http\Requests\API\CreateApprovalsAPIRequest;
use WizPack\Workflow\Http\Requests\API\UpdateApprovalsAPIRequest;
use WizPack\Workflow\Models\Approvals;
use Illuminate\Http\Request;
use WizPack\Workflow\Http\Controllers\AppBaseController;
use WizPack\Workflow\Repositories\API\ApprovalsRepository;


/**
 * Class ApprovalsController
 * @package App\Http\Controllers\API
 */

class ApprovalsAPIController extends AppBaseController
{
    /** @var  ApprovalsRepository */
    private $approvalsRepository;

    public function __construct(ApprovalsRepository $approvalsRepo)
    {
        $this->approvalsRepository = $approvalsRepo;
    }

    /**
     * @param Request $request
     * @return Response
     *
     * @SWG\Get(
     *      path="/approvals",
     *      summary="Get a listing of the Approvals.",
     *      tags={"Approvals"},
     *      description="Get all Approvals",
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
     *                  @SWG\Items(ref="#/definitions/Approvals")
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
        $approvals = $this->approvalsRepository->all(
            $request->except(['skip', 'limit']),
            $request->get('skip'),
            $request->get('limit')
        );

        return $this->sendResponse($approvals->toArray(), 'Approvals retrieved successfully');
    }

    /**
     * @param CreateApprovalsAPIRequest $request
     * @return Response
     *
     * @throws \Prettus\Validator\Exceptions\ValidatorException
     * @SWG\Post(
     *      path="/approvals",
     *      summary="Store a newly created Approvals in storage",
     *      tags={"Approvals"},
     *      description="Store Approvals",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="body",
     *          in="body",
     *          description="Approvals that should be stored",
     *          required=false,
     *          @SWG\Schema(ref="#/definitions/Approvals")
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
     *                  ref="#/definitions/Approvals"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function store(CreateApprovalsAPIRequest $request)
    {
        $input = $request->all();

        $approvals = $this->approvalsRepository->create($input);

        return $this->sendResponse($approvals->toArray(), 'Approvals saved successfully');
    }

    /**
     * @param int $id
     * @return Response
     *
     * @SWG\Get(
     *      path="/approvals/{id}",
     *      summary="Display the specified Approvals",
     *      tags={"Approvals"},
     *      description="Get Approvals",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of Approvals",
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
     *                  ref="#/definitions/Approvals"
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
        /** @var Approvals $approvals */
        $approvals = $this->approvalsRepository->find($id);

        if (empty($approvals)) {
            return $this->sendError('Approvals not found');
        }

        return $this->sendResponse($approvals->toArray(), 'Approvals retrieved successfully');
    }

    /**
     * @param int $id
     * @param UpdateApprovalsAPIRequest $request
     * @return Response
     *
     * @throws \Prettus\Validator\Exceptions\ValidatorException
     * @SWG\Put(
     *      path="/approvals/{id}",
     *      summary="Update the specified Approvals in storage",
     *      tags={"Approvals"},
     *      description="Update Approvals",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of Approvals",
     *          type="integer",
     *          required=true,
     *          in="path"
     *      ),
     *      @SWG\Parameter(
     *          name="body",
     *          in="body",
     *          description="Approvals that should be updated",
     *          required=false,
     *          @SWG\Schema(ref="#/definitions/Approvals")
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
     *                  ref="#/definitions/Approvals"
     *              ),
     *              @SWG\Property(
     *                  property="message",
     *                  type="string"
     *              )
     *          )
     *      )
     * )
     */
    public function update($id, UpdateApprovalsAPIRequest $request)
    {
        $input = $request->all();

        /** @var Approvals $approvals */
        $approvals = $this->approvalsRepository->find($id);

        if (empty($approvals)) {
            return $this->sendError('Approvals not found');
        }

        $approvals = $this->approvalsRepository->update($input, $id);

        return $this->sendResponse($approvals->toArray(), 'Approvals updated successfully');
    }

    /**
     * @param int $id
     * @return Response
     *
     * @throws \Exception
     * @SWG\Delete(
     *      path="/approvals/{id}",
     *      summary="Remove the specified Approvals from storage",
     *      tags={"Approvals"},
     *      description="Delete Approvals",
     *      produces={"application/json"},
     *      @SWG\Parameter(
     *          name="id",
     *          description="id of Approvals",
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
        /** @var Approvals $approvals */
        $approvals = $this->approvalsRepository->find($id);

        if (empty($approvals)) {
            return $this->sendError('Approvals not found');
        }

        $approvals->delete();

        return $this->sendSuccess('Approvals deleted successfully');
    }
}
