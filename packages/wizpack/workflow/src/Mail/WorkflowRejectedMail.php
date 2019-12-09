<?php

namespace  WizPack\Workflow\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class WorkflowRejectedMail extends Mailable
{
    use Queueable, SerializesModels;

    public $workflow;

    public $approvedStep;

    public $sentBy;

    public $url;

    public $text;

    /**
     * Create a new message instance.
     *
     * @param $workflow
     * @param $approvedStep
     * @param $sentBy
     */
    public function __construct($workflow, $approvedStep, $sentBy)
    {
        $this->workflow = $workflow;
        $this->approvedStep = $approvedStep;
        $this->sentBy = $sentBy;
        $this->url = 'wizpack/approvals/'.$workflow['id'];
        $this->text = 'View approval';
    }


    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        $subject = "Approval request: #". $this->workflow['id'].' '.$this->workflow['name'];

        return $this->subject($subject)->view('wizpack::emails.workflow-step-rejected');
    }
}
