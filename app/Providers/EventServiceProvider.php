<?php

namespace App\Providers;

use App\Events\Workflow\ApprovalRequestRaised;
use App\Events\Workflow\WorkflowStageApproved;
use App\Listeners\Workflow\WhenApprovalRequestIsRaised;
use App\Listeners\Workflow\WhenWorkflowStageIsApproved;
use Illuminate\Support\Facades\Event;
use Illuminate\Auth\Events\Registered;
use Illuminate\Auth\Listeners\SendEmailVerificationNotification;
use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;

class EventServiceProvider extends ServiceProvider
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
