<?php

namespace WizPack\Workflow\Repositories;

use WizPack\Workflow\Models\WorkflowStageApprovers;
use Prettus\Repository\Eloquent\BaseRepository;

/**
 * Class WorkflowStageApproversRepository
 * @package App\Repositories
 * @version November 18, 2019, 9:33 pm UTC
*/

class WorkflowStageApproversRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'user_id',
        'granted_by',
        'workflow_stage_id',
        'workflow_stage_type_id'
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
        return WorkflowStageApprovers::class;
    }
}
