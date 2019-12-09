<?php

namespace WizPack\Workflow\Transformers;

use WizPack\Workflow\Models\Approvals;
use Illuminate\Support\Collection;
use League\Fractal\TransformerAbstract;

/**
 * Class ApprovalTransformer.
 *
 * @package namespace App\Transformers\Workflow;
 */
class ApprovalTransformer extends TransformerAbstract
{
    /**
     * Transform the Approval entity.
     *
     * @param Approvals $model
     *
     * @return array
     */
    public function transform(Approvals $model)
    {
        $stages = $this->getStages($model);

        $currentStage = $this->getCurrentApprovalStage($stages);

        $approvalHasRejection = $currentStage->filter(function ($stage){
            return(!empty($stage['rejected_by']));
        })->isNotEmpty();

        return [
            "workflowDetails" => $this->getApprovalDetails($model),
            "approvalStagesStepsAndApprovers" => $stages,
            "workflowInfo" => $model->approvable,
            "currentApprovalStage" => $currentStage,
            "currentStageApprovers" => $this->getCurrentApprovalStageApprovers($currentStage),
            "approvalRejected" =>$approvalHasRejection
        ];
    }

    /**
     * @param $stage
     * @return mixed
     */
    public function getCurrentApprovalStageApprovers($stage)
    {
        return collect($stage)->map(function ($stage) {
            return $stage['workflow_approvers'];

        });
    }

    /**
     * @param $stages
     * @return Collection
     */
    public function getCurrentApprovalStage($stages)
    {
        $stages = collect($stages)->unique('workflow_stage_type_id')->filter(function ($stage) {
            //filter out approved steps in a stage
            $stageApprovals = collect($stage['workflow_steps'])->map(function ($step) {
                if (empty($step['approved_at']) || empty($step['approved_at'])) {
                    return true;
                }
                return false;
            })->toArray();

            return (!in_array(false, $stageApprovals));
        });

        //based on weights get the minimum weight
        $weight = collect($stages)->pluck('weight')->sort()->first();

        //get all stages with the minimum weight
        return $stages->filter(function ($stage) use ($weight) {
            return $stage['weight'] == $weight;
        });

    }

    /**
     * @param $model
     * @return array
     */
    public function getApprovalDetails($model)
    {
        return [
            'id' => (int)$model->id,
            "user_id" => $model->user_id,
            "workflow_type" => $model->workflow_type,
            "name" => $model->workflow->name,
            "model_id" => $model->model_id,
            "model_type" => "App\Models\Leaves",
            "collection_name" => "leave_approval",
            "sent_by" => $model->sentBy,
            "approved" => $model->approved,
            "approved_at" => $model->approved_at,
            "rejected_at" => $model->rejected_at,
            "awaiting_stage_id" => $model->awaiting_stage_id,
            "created_by" => $model->user->name,
            'created_at' => $model->created_at->format('d-M-Y'),
            'updated_at' => $model->updated_at->format('d-M-Y')
        ];
    }


    /**
     * @param $model
     * @return mixed
     */
    public function getStages($model)
    {
        return $model->workflowSteps->unique('workflow_stage_id')->map(function ($stepStage) use ($model) {
            $stage = $stepStage->workflowStage;
            $stageApprovers = $this->getStageApprovers($stage);
            $steps = $this->getStepsInStage($stage, $model->workflowSteps);
            $approvedBy =  $this->getApprovedBy($steps);
            $rejectedBy =  $this->getRejectedBy($steps);

            return [
                "id" => $stage->id,
                "workflow_stage_type_id" => $stage->workflowStageType->id,
                "workflow_stage_type_name" => $stage->workflowStageType->name,
                "workflow_type_id" => $stage->workflow_type_id,
                "workflow_type_name" => $stepStage->workflow->name,
                "weight" => $stage->weight,
                "created_at" => formatToDate($stage->created_at),
                "updated_at" => formatToDate($stage->updated_at),
                "workflow_approvers" => $stageApprovers,
                "workflow_steps" => $steps,
                "approved_by" => $approvedBy->toArray(),
                "rejected_by" => $rejectedBy->toArray(),
                "is_stage_complete"=>(!$approvedBy->isEmpty()) || (!$rejectedBy->isEmpty()),
                "is_current_stage" => $this->checkIfIsCurrentStage($model->workflowSteps, $stage),
                "canApproveStage" => $stageApprovers->contains('user_id', auth()->id())
            ];
        })->sortBy('workflow_stage_type_name')->sortBy('weight');
    }

    /**
     * @param $steps
     * @return Collection
     */
    public function getApprovedBy($steps)
    {
        return collect($steps)->filter(function ($step) {
            return !empty($step['approved_at']);
        });

    }

    /**
     * @param $steps
     * @return Collection
     */
    public function getRejectedBy($steps)
    {
        return collect($steps)->filter(function ($step) {
            return !empty($step['rejected_at']);
        });

    }

    /**
     * @param $steps
     * @param $currentStage
     * @return bool
     */
    public function checkIfIsCurrentStage($steps, $currentStage)
    {
        $result = collect($steps)->pluck('workflowStage')->unique('workflow_stage_type_id')
            ->filter(function ($stage) use ($steps) {
                //filtering steps for the stage
                $steps = collect($steps)->filter(function ($step) use ($stage) {
                    return $stage['id'] == $step['workflow_stage_id'];
                });

                //filtering unapproved steps
                $stepApprovals = collect($steps)->map(function ($step) use ($stage) {
                    if ((empty($step['approved_at']) || empty($step['approved_at']))) {
                        return true;
                    }
                    return false;
                })->toArray();

                return !in_array(false, $stepApprovals);
            });


        //based on weights get the minimum weight
        $weight = collect($result)->pluck('weight')->sort()->first();

        //get all stages with the minimum weight
        $pendingStages = $result->filter(function ($stage) use ($weight) {
            return $stage['weight'] == $weight;
        });

        return collect($pendingStages)->contains('id', $currentStage->id);
    }

    /**
     * @param $stage
     * @return mixed
     */
    public function getStageApprovers($stage)
    {
        return $stage->workflowApprovers->map(function ($approver) {

            return [
                "id" => $approver->id,
                "user_id" => $approver->user_id,
                "approver_name" => $approver->user->name,
                "approver_email" => $approver->user->email,
                "granted_by" => $approver->granted_by,
                "granted_by_name" => $approver->grantedBy->name,
                "workflow_stage_id" => $approver->workflow_stage_id,
                "workflow_stage_type_id" => $approver->workflow_stage_type_id,
                "deleted_at" => formatToDate($approver->deleted_at),
                "created_at" => formatToDate($approver->created_at),
                "updated_at" => formatToDate($approver->updated_at),
            ];
        });

    }

    /**
     * @param $stage
     * @param $steps
     * @return Collection
     */
    public function getStepsInStage($stage, $steps)
    {
        return $this->getSteps(collect($steps)->filter(function ($step) use ($stage) {
            return $step->workflow_stage_id == $stage->id;
        }));
    }

    /**
     * @param $steps
     * @return Collection
     */
    public function getSteps($steps)
    {
        return collect($steps)->map(function ($step) {
            return [
                "id" => $step->id,
                "workflow_stage_id" => $step->workflow_stage_id,
                "workflow_id" => $step->workflow_id,
                "user_id" => $step->user_id,
                "user_name" => $step->user->name,
                "approved_at" => $step->approved_at,
                "rejected_at" => $step->rejected_at,
                "weight" => $step->weight,
                "deleted_at" => formatToDate($step->deleted_at),
                "created_at" => formatToDate($step->created_at),
                "updated_at" => formatToDate($step->updated_at),
            ];
        });
    }
}
