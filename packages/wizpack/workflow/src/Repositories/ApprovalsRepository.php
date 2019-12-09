<?php

namespace WizPack\Workflow\Repositories;

use WizPack\Workflow\Models\Approvals;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Prettus\Repository\Eloquent\BaseRepository;

/**
 * Class ApprovalsRepository
 * @package App\Repositories
 * @version November 18, 2019, 10:13 pm UTC
 */
class ApprovalsRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'user_id',
        'workflow_type',
        'model_id',
        'model_type',
        'collection_name',
        'payload',
        'sent_by',
        'approved',
        'approved_at',
        'rejected_at',
        'awaiting_stage_id'
    ];

    /**
     * Return searchable fields
     *
     * @return array
     */
    public function getFieldsSearchable()
    {
        return $this->fieldSearchable;
    }

    /**
     * Configure the Model
     **/
    public function model()
    {
        return Approvals::class;
    }

    public function myApprovals()
    {

        $with = [
            'user',
            'sentBy',
            'workflowSteps.user',
            'workflowSteps.user',
            'workflowSteps.workflowStage.workflowApprovers.user',
            'workflowSteps.workflowStage.workflowStageType',
            'workflow.workflowStages.workflowApprovers',
            'workflow.workflowStages.workflowStageType',
            'workflow.workflowStages.workflowSteps.user',
            'workflow.workflowStages' => function ($q) {
                return $q->orderBy('weight', 'asc');
            },
            'approvable'

        ];
        $approvals = $this->model->MyApprovals()->with($with);

        return $approvals;
    }

    /**
     * @param $id
     * @return Builder|Model
     */
    public function getApprovalSteps($id)
    {
        $approvals = $this->myApprovals()->limit(1)
            ->where('id', $id);

        return $approvals;
    }
}
