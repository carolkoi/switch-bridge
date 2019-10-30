<?php

namespace App\Repositories;

use App\Models\Allocation;
use App\Repositories\BaseRepository;

/**
 * Class AllocationRepository
 * @package App\Repositories
 * @version October 30, 2019, 7:33 am UTC
*/

class AllocationRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'user_type',
        'client_id',
        'user_id',
        'type',
        'template_id'
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
        return Allocation::class;
    }
}
