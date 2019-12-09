<?php

namespace WizPack\Workflow\Repositories;

use WizPack\Workflow\Models\WorkflowType;
use Prettus\Repository\Eloquent\BaseRepository;

/**
 * Class WorkflowTypesRepository
 * @package App\Repositories
 * @version November 17, 2019, 1:33 am UTC
*/

class WorkflowTypesRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'name',
        'slug'
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
