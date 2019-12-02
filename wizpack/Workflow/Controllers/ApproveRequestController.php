<?php

namespace WizPack\Workflow\Controllers;

use WizPack\Workflow\Events\WorkflowStageApproved;
use WizPack\Workflow\Repositories\ApprovalsRepository;
use WizPack\Workflow\Repositories\WorkflowStageApproversRepository;
use WizPack\Workflow\Repositories\WorkflowStepRepository;
use WizPack\Workflow\Transformers\ApprovalTransformer;
use Carbon\Carbon;
use Illuminate\Http\RedirectResponse;
use League\Fractal\Resource\Collection;
use Laracasts\Flash\Flash;
use League\Fractal\Manager;
use Prettus\Validator\Exceptions\ValidatorException;

class ApproveRequestController extends AppBaseController
{
    /** @var  ApprovalsRepository */
    private $approvalsRepository;
    private $approversRepository;
    private $workflowStepRepository;

    public function __construct(
        ApprovalsRepository $approvalsRepo,
        WorkflowStageApproversRepository $approversRepository,
        WorkflowStepRepository $workflowStepRepository
    )
    {
        $this->approvalsRepository = $approvalsRepo;
        $this->approversRepository = $approversRepository;
        $this->workflowStepRepository = $workflowStepRepository;
    }

    /**
     * @param $workflowApprovalId
     * @param $stageId
     * @return RedirectResponse
     * @throws ValidatorException
     */
    public function handle($workflowApprovalId, $stageId)
    {
        $workflow = $this->approvalsRepository->getApprovalSteps($workflowApprovalId)->get();

        $transformedResult = new Collection($workflow, new ApprovalTransformer());

        $data = collect((new Manager())->createData($transformedResult)->toArray()['data']);

        $approvers = $data->pluck('currentStageApprovers')->flatten(2);

        $currentStage = $data->pluck('currentApprovalStage')->flatten(1)->first();

        if (!$approvers->contains('user_id', auth()->id())) {
            Flash::error('You are not authorized to approve this request');

            return redirect('/approvals/' . $workflowApprovalId);
        }

        $workflowStageToBeApproved = $data->pluck('currentApprovalStage')->flatten(1)->first();

        $workflow = $data->pluck('workflowDetails')->first();

        $stageId = $workflowStageToBeApproved['workflow_stage_type_id'] ?: $stageId;

        $approvedStep = $this->workflowStepRepository->updateOrCreate([
            'workflow_stage_id' => $stageId,
            'workflow_id' => $workflow['id'],
            'weight' => $currentStage['weight'],
            'user_id' => auth()->id()

        ], [
            'workflow_stage_id' => $stageId,
            'workflow_id' => $workflow['id'],
            'user_id' => auth()->id(),
            'approved_at' => Carbon::now()

        ]);
        if ($approvedStep) {

            event(new WorkflowStageApproved($data, $approvedStep));

            Flash::success('Stage Approved successfully');
            return redirect('/approvals/' . $workflowApprovalId);
        }

        Flash::success('An error occurred stage not npproved ');
        return redirect()->back();

    }

    /**
     * retrieves approval stages pending approval
     *
     * @param $workflow
     * @return mixed
     */
    public function getStagesPendingApproval($workflow)
    {
        $approvedStages = $this->getApprovedStages($workflow)->pluck('id')->toArray();
        return collect($workflow->workflowSteps)
            ->filter(function ($step) use ($approvedStages) {
                return !in_array($step->workflow_stage_id, $approvedStages);
            })->pluck('workflowStage')
            ->sortBy('weight')
            ->unique('workflow_stage_type_id');
    }

    /**
     * get the next  stage to be approved
     *
     * @param $workflow
     * @return mixed
     */
    public function getNextStageToBeApproved($workflow)
    {
        return $this->getStagesPendingApproval($workflow)->first();
    }

    /**
     * get the initiator and approvers of a request
     *
     * @param $workflow
     * @return void
     */
    public function getApprovers($workflow)
    {
        $workflowActiveStage = $this->getNextStageToBeApproved($workflow);

        return $this->approversRepository->with('user')->findWhere([
            'workflow_stage_id' => $workflowActiveStage->id,
            'workflow_stage_type_id' => $workflowActiveStage->workflow_stage_type_id
        ])->pluck('user')->unique('email');
    }

    /**
     * @param $workflow
     * @return Collection
     */
    public function getInitiators($workflow)
    {
        return collect([$workflow->user, $workflow->sentBy])->reject(function ($user) {
            return empty($user);
        })->unique('email');
    }

    /**
     * @param $workflow
     * @return mixed
     */
    public function getSteps($workflow)
    {
        return $workflow->workflowSteps;
    }

    /**
     * @param $workflow
     * @return mixed
     */
    public function getApprovedStages($workflow)
    {
        return collect($workflow->workflowSteps)
            ->filter(function ($step) {
                return !empty($step->approved_at) || !empty($step->rejected_at);
            })->pluck('workflowStage')
            ->sortBy('weight')
            ->unique('workflow_stage_type_id');
    }
}
