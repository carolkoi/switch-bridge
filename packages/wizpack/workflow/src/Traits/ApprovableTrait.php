<?php

namespace WizPack\Workflow\Traits;

use Carbon\Carbon;
use WizPack\Workflow\Events\ApprovalRequestRaised;
use Illuminate\Support\Facades\Log;
use WizPack\Workflow\Models\Approvals;

trait ApprovableTrait
{
    protected static $approvalType = __CLASS__;
    protected static $workflowType = 'transaction_approval';
    protected static $workflowName = 'Transaction Approval';

    /**
     *model listener
     */
    protected static function bootApprovableTrait()
    {
        static::created(
            function ($model) {
//                self::addApproval($model, self::$workflowType);
            }
        );


        static::deleted(
            function ($model) {
                $model->approval->delete();
            }
        );
    }

    /**
     * retrieves connected approvals
     *
     * @param $query
     * @return mixed
     */
    public function scopeApprovalsPending($query)
    {
        return $query->whereHas('approvals', function ($q) {
            return $q->whereNull('approved_on');
        });
    }

    /**
     * relationship to the workflow
     *
     * @return mixed
     */
    public function approvals()
    {
        return $this->morphMany(self::$approvalType, 'model');
    }

    /**
     * relationship to the workflow gets
     *
     * @return mixed
     */
    public function approval()
    {
        return $this->morphOne(Approvals::class, 'approval', 'model_type', 'model_id', 'id');
    }

    /**
     * @param $model
     * @param string $workflowType
     * @return array|null
     */
    public static function addApproval($model, $workflowType = null)
    {
        $workflowType = $workflowType ?: self::$workflowType;
        return event(new ApprovalRequestRaised($model, $workflowType));
    }

    /**
     * formatting the approved field
     *
     * @return string
     */
    public function approvedLabel()
    {
        if (!empty($this->approved_at)) {
            return "<a href=" . env('APP_URL') . '/upesi/approvals/' . $this->approval->id . " class='label label-success'> Approved</a>";
        }

        if (!empty($this->rejected_at)) {
            return "<a href=" . env('APP_URL') . '/upesi/approvals/' . $this->approval->id . " class='label label-danger'> Rejected</a>";
        }

        return "<a href=" . env('APP_URL') . '/upesi/approvals/' . $this->approval->id . " class='label label-info'> Pending</a>";
    }
}
