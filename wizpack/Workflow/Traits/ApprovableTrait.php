<?php

namespace WizPack\Workflow\Traits;

use WizPack\Workflow\Events\ApprovalRequestRaised;
use Illuminate\Support\Facades\Log;

trait ApprovableTrait
{
    protected static $approvalType = __CLASS__;
    protected static $workflowType = 'survey_approval';
    protected static $workflowName = 'Survey Approval';

    /**
     *model listener
     */
    protected static function bootApprovableTrait()
    {
        static::created(
            function ($model) {
                self::addApproval($model, self::$workflowType);
            }
        );


        static::deleted(
            function ($model) {
                Log::info(serialize($model) . " " . self::$approvalType);
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
     * @param $model
     * @param string $workflowType
     * @return array|null
     */
    public static function addApproval($model = null, $workflowType = null)
    {
        $workflowType = $workflowType ?: self::$workflowType;
        $model = $model ?: self::$approvalType;

        return event(new ApprovalRequestRaised($model, $workflowType));
    }

    /**
     * marking the approval as complete
     * @param $id
     */
    public function markApprovalComplete($id)
    {
        $model = self::find($id);
        $model->approved = 1;
        $model->save();
    }

    /**
     * formatting the approved field
     *
     * @return string
     */
    public function approvedLabel()
    {
        if ($this->approved) {
            return "<span class='label label-success'> Approved</span>";
        }

        return "<span class='label label-info'> Pending</span>";
    }
}
