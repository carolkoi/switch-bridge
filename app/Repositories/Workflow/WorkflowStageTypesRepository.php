<?php

namespace App\Repositories\Workflow;

use App\Models\Workflow\WorkflowStageType;
use Prettus\Repository\Eloquent\BaseRepository;

/**
 * Class WorkflowStageTypesRepository
 * @package App\Repositories
 * @version November 17, 2019, 1:45 am UTC
*/

class WorkflowStageTypesRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'name',
        'slug',
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
        return WorkflowStageType::class;
    }
}
