<?php

namespace App\Listeners\Workflow;

use App\Mail\Workflow\WorkflowApprovalRequestMail;
use App\Models\Workflow\Approvals;
use App\Models\Workflow\WorkflowStage;
use App\Models\Workflow\WorkflowStep;
use App\Models\Workflow\WorkflowType;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;

class WhenApprovalRequestIsRaised
{
    /**
     * Create the event listener.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     *
     * @param object $event
     * @return void
     */
    public function handle($event)
    {
        Log::info("testing");
        //getting all the approval stages and their approvers
        $workflow = WorkflowType::Where([
            'slug' => $event->workflowType
        ])->with(
            [
                'workflowStages' => function ($q) {
                    return $q->orderBy('weight', 'asc');
                }, 'workflowStages.workflowApprovers',
                 'workflowStages.workflowApprovers.user'
            ]
        )->latest()->first();

        //first approval stage
        $firstApprovalStage = $workflow->workflowStages->first();

        //saving the approval
        $data = new Approvals([
            'user_id' => Auth::id(),
            'sent_by' => Auth::id(),
            'workflow_type' => $event->workflowType,
            'collection_name' => $event->workflowType,
            'model_id' => $event->model->model_id,
            'awaiting_stage_id' => $firstApprovalStage->id
        ]);

        $workflowAdded = $event->model->approvals()->save($data);

        //create approval steps with their approvers
        $response = $this->addWorkflowSteps($workflow->workflowStages, $workflowAdded);

        //send mail to first approvers


        if($response){
            $approvers = $workflow->workflowStages->pluck('workflowApprovers')->first()->pluck('user')->toArray();
            Mail::to($approvers)
                ->cc(Auth::user())
                ->send(new WorkflowApprovalRequestMail($workflow, $workflow->workflowStages, $event->model, $response->first()));
        }

    }

    public function addWorkflowSteps($workflowStagesAndApprovers, $workflow)
    {
        return collect($workflowStagesAndApprovers)->map(function ($stage) use ($workflow) {
            $weight = $stage->weight;
            // for each stage collect a list of approvers
            $workflowSteps = $stage->workflowApprovers->map(function ($step) use ($workflow, $weight) {
                return new WorkflowStep([
                    'workflow_stage_id' => $step->workflow_stage_id,
                    'workflow_id' => $workflow->id,
                    'user_id' => $step->user_id,
                    'weight' => $weight,
                ]);
            });

            $workflowStage = WorkflowStage::find($stage->id);

            return $workflowStage->workflowSteps()->saveMany($workflowSteps);

        })->flatten(1);

    }
}
