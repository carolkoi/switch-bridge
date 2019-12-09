<?php

namespace WizPack\Workflow\Repositories;

use  WizPack\Workflow\Models\WorkflowStage;
use Prettus\Repository\Eloquent\BaseRepository;

/**
 * Class WorkflowStagesRepository
 * @package App\Repositories
 * @version November 17, 2019, 1:48 am UTC
*/

class WorkflowStagesRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'workflow_stage_type_id',
        'workflow_type_id',
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
        return WorkflowStage::class;
    }
}
