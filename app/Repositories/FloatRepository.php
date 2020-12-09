<?php

namespace App\Repositories;

use App\Models\Float;
use App\Repositories\BaseRepository;

/**
 * Class FloatRepository
 * @package App\Repositories
 * @version December 9, 2020, 9:32 am UTC
*/

class FloatRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'partnerid',
        'description',
        'transactionnumber',
        'debit',
        'credit',
        'amount',
        'runningbal',
        'datetimeadded',
        'addedby',
        'ipaddress'
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
        return Float::class;
    }
}
