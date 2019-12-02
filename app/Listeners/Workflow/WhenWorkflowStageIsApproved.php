<?php

namespace App\Listeners\Workflow;

use App\Http\Controllers\Workflow\WorkflowController;
use App\Mail\Workflow\WorkflowApprovedMail;
use App\Models\Workflow\Approvals;
use Carbon\Carbon;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;

class WhenWorkflowStageIsApproved
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
        $workflow = collect($event->workflow);
        $approvedStep = collect($event->approvedStep);
        $workflowPayload = $workflow->pluck('workflowDetails')->first();
        $currentStageApprovers = $workflow->pluck('currentStageApprovers')->flatten(1);


        $nextAprrovalWorkflowInfo = (app(WorkflowController::class)->getWorkflowInfo($workflowPayload['id']));
        $nextStageApprovers = $nextAprrovalWorkflowInfo->pluck('currentStageApprovers')->flatten(1);
        $nextApprovalStage = $nextAprrovalWorkflowInfo->pluck('currentApprovalStage')->flatten(1);
        $nextStageId = $nextApprovalStage->first()['workflow_stage_type_id'];

        //set next approval stage
        $nextStageUpdate = Approvals::find($workflowPayload['id']);

        if (!empty($nextStageId)) {
            $nextStageUpdate->awaiting_stage_id = $nextStageId;
            $nextStageUpdate->save();
        }

        if (empty($nextStageId)) {
            $nextStageUpdate->approved_on = Carbon::now();
            $nextStageUpdate->approved = 1;
            $nextStageUpdate->save();
            //mark workflow complete
            app($nextStageUpdate->model_type)->markApprovalComplete($nextStageUpdate->model_id);
        }


        $allApprovers = $currentStageApprovers->merge($nextStageApprovers)->flatten(1)->unique('user_id')->map(function ($approver) {
            return [
                'email' => $approver['approver_email'],
                'name' => $approver['approver_name']
            ];
        });
        $sentBy = $workflowPayload['sent_by'];

        Mail::to($allApprovers)
            ->cc($sentBy)
            ->send(new WorkflowApprovedMail($workflowPayload, $approvedStep, $sentBy));
    }
}
