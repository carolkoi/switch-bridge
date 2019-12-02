<?php

namespace WizPack\Workflow\Providers;

use WizPack\Workflow\Events\ApprovalRequestRaised;
use WizPack\Workflow\Events\WorkflowStageApproved;
use WizPack\Workflow\Listeners\WhenApprovalRequestIsRaised;
use WizPack\Workflow\Listeners\WhenWorkflowStageIsApproved;
use Illuminate\Support\Facades\Event;
use Illuminate\Auth\Events\Registered;
use Illuminate\Auth\Listeners\SendEmailVerificationNotification;
use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;

class WorkflowApprovalServiceProvider extends ServiceProvider
{
    /**
     * The event listener mappings for the application.
     *
     * @var array
     */
    protected $listen = [
        Registered::class => [
            SendEmailVerificationNotification::class,
        ],
        ApprovalRequestRaised::class => [
            WhenApprovalRequestIsRaised::class,
        ],
        WorkflowStageApproved::class => [
            WhenWorkflowStageIsApproved::class
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
