<?php

namespace WizPack\Workflow\Repositories\API;

use WizPack\Workflow\Models\WorkflowStageApprovers;
use App\Repositories\BaseRepository;

/**
 * Class WorkflowStageApproversRepository
 * @package WizPack\Workflow\Repositories\API
 * @version December 1, 2019, 12:59 am UTC
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
