<?php

namespace WizPack\Workflow\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Queue\SerializesModels;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class WorkflowStageRejected
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $workflow;

    public $approvedStep;

    /**
     * Create a new event instance.
     *
     * @param $workflow
     * @param $approvedStep
     */
    public function __construct($workflow, $approvedStep)
    {
        $this->workflow = $workflow;
        $this->approvedStep = $approvedStep;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return Channel|array
     */
    public function broadcastOn()
    {
        return new PrivateChannel('channel-name');
    }
}
