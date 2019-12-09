<?php

namespace WizPack\Workflow\Repositories\API;

use WizPack\Workflow\Models\WorkflowStepCheckList;
use WizPack\Workflow\Repositories\BaseRepository;

/**
 * Class WorkflowStepChecklistRepository
 * @package WizPack\Workflow\Repositories\API
 * @version December 1, 2019, 1:02 am UTC
*/

class WorkflowStepChecklistRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'name',
        'user_id',
        'text',
        'status',
        'workflow_steps_id'
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
        return WorkflowStepCheckList::class;
    }
}
