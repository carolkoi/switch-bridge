<?php

namespace WizPack\Workflow\Http\Controllers;

use Carbon\Carbon;
use Illuminate\Http\RedirectResponse;
use Laracasts\Flash\Flash;
use League\Fractal\Manager;
use League\Fractal\Resource\Collection;
use Prettus\Validator\Exceptions\ValidatorException;
use WizPack\Workflow\Events\WorkflowStageRejected;
use WizPack\Workflow\Repositories\ApprovalsRepository;
use WizPack\Workflow\Repositories\WorkflowStageApproversRepository;
use WizPack\Workflow\Repositories\WorkflowStepRepository;
use WizPack\Workflow\Transformers\ApprovalTransformer;


class RejectRequestController extends AppBaseController
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
        $this->middleware('auth');
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
            Flash::error('You are not authorized to reject this request');

            return redirect('/wizpack/approvals/' . $workflowApprovalId);
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
            'rejected_at' => Carbon::now()

        ]);
        if ($approvedStep) {

            event(new WorkflowStageRejected($data, $approvedStep));

            Flash::success('Stage Approved successfully');
            return redirect('/wizpack/approvals/' . $workflowApprovalId);
        }

        Flash::success('An error occurred stage not approved ');
        return redirect()->back();

    }
}
