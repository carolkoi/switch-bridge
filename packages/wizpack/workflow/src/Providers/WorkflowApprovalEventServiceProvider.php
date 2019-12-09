<?php

namespace WizPack\Workflow\Providers;

use WizPack\Workflow\Events\ApprovalRequestRaised;
use WizPack\Workflow\Events\WorkflowStageApproved;
use WizPack\Workflow\Events\WorkflowStageRejected;
use WizPack\Workflow\Listeners\WhenApprovalRequestIsRaised;
use WizPack\Workflow\Listeners\WhenWorkflowStageIsApproved;
use Illuminate\Auth\Events\Registered;
use Illuminate\Auth\Listeners\SendEmailVerificationNotification;
use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;
use WizPack\Workflow\Listeners\WhenWorkflowStageIsRejected;

class WorkflowApprovalEventServiceProvider extends ServiceProvider
{
    /**
     * The event listener mappings for the application.
     *
     * @var array
     */
    protected $listen = [
        ApprovalRequestRaised::class => [
            WhenApprovalRequestIsRaised::class,
        ],
        WorkflowStageApproved::class => [
            WhenWorkflowStageIsApproved::class
        ],
        WorkflowStageRejected::class=>[
            WhenWorkflowStageIsRejected::class
        ]
    ];

    /**
     * Register any events for your application.
     *
     * @return void
     */
    public function boot()
    {
        parent::boot();

        //
    }
}
