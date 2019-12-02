<?php

namespace  WizPack\Workflow\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class WorkflowApprovalRequestMail extends Mailable
{
    use Queueable, SerializesModels;

    public $workflow;
    public $stageApprovers;
    public $model;
    public $url;
    public $text;

    /**
     * Create a new message instance.
     *
     * @param $workflow
     * @param $stageApprovers
     * @param $model
     * @param $workflowInfo
     */
    public function __construct($workflow, $stageApprovers, $model, $workflowInfo)
    {
        $this->workflow =$workflow;
        $this->stageApprovers = $stageApprovers;
        $this->model = $model;
        $this->url = 'approvals/'.$workflowInfo['workflow_id'];
        $this->text = 'view approval';
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        $subject= $this->workflow->name. " request Approved";

        return $this->subject($subject)->view('workflow.emails.approval-request');
    }
}
