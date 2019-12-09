<?php

namespace WizPack\Workflow\Interfaces;

interface ApprovableInterface
{
    public function scopeApprovalsPending($query);

    /**
     * morph relationship to the workflow approval
     * the method is defined in the trait
     *
     * @return mixed
     */
    public function approval();

    /**
     * @return mixed
     */
    public function approvals();

    /**
     * a link to view the approval details i.e. a link to show in your controller
     * method to be defined on the model
     *
     * @return mixed
     */
    public function previewLink();

    /**
     * the label to be shown at the approved field
     * @return mixed
     */
    public function approvedLabel();

    /**
     * the method is defined in the trait, can be called directly in the controller
     * creates a new stage for approval
     *
     * @param $model
     * @param null $workflowType
     * @return mixed
     */
    public static function addApproval($model, $workflowType = null);

    /**
     * The field to be marked complete once the approval process is done
     * the method is defined on the trait,
     *
     * @param $id
     * @return mixed
     */
    public function markApprovalComplete($id);

    /**
     * The field to be marked rejected when an approval process is rejected
     * the method is defined on the trait,
     *
     * @param $id
     * @return mixed
     */
    public function markApprovalAsRejected($id);
}