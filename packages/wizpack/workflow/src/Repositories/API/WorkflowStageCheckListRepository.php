<?php

namespace WizPack\Workflow\Repositories\API;

use WizPack\Workflow\Models\WorkflowStageCheckList;
use App\Repositories\BaseRepository;

/**
 * Class WorkflowStageCheckListRepository
 * @package WizPack\Workflow\Repositories\API
 * @version December 1, 2019, 12:43 am UTC
*/

class WorkflowStageCheckListRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'name',
        'text',
        'status',
        'workflow_stages_id'
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
        return WorkflowStageCheckList::class;
    }
}
