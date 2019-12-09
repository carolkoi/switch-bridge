<?php

namespace WizPack\Workflow\Repositories\API;

use WizPack\Workflow\Models\WorkflowStep;
use App\Repositories\BaseRepository;

/**
 * Class WorkflowStepRepository
 * @package WizPack\Workflow\Repositories\API
 * @version December 1, 2019, 12:52 am UTC
*/

class WorkflowStepRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'workflow_stage_id',
        'workflow_id',
        'user_id',
        'approved_at',
        'rejected_at',
        'weight'
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
        return WorkflowStep::class;
    }
}
