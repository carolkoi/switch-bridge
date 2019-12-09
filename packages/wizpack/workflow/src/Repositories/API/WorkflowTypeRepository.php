<?php

namespace WizPack\Workflow\Repositories\API;

use WizPack\Workflow\Models\WorkflowType;
use App\Repositories\BaseRepository;

/**
 * Class WorkflowTypeRepository
 * @package WizPack\Workflow\Repositories\API
 * @version December 1, 2019, 12:55 am UTC
*/

class WorkflowTypeRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'name',
        'slug',
        'type'
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
        return WorkflowType::class;
    }
}
