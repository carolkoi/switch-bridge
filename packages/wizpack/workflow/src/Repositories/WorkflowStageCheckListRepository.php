<?php

namespace WizPack\Workflow\Repositories;

use  WizPack\Workflow\Models\WorkflowStageCheckList;
use Prettus\Repository\Eloquent\BaseRepository;

/**
 * Class WorkflowStageCheckListRepository
 * @package App\Repositories
 * @version November 17, 2019, 1:55 am UTC
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
