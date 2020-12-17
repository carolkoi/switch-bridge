<?php

namespace App\Repositories;

use App\Models\FloatBalance;
use App\Repositories\BaseRepository;

/**
 * Class FloatBalanceRepository
 * @package App\Repositories
 * @version December 9, 2020, 10:29 am UTC
*/

class FloatBalanceRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'description',
        'transactionnumber',
        'debit',
        'credit',
        'amount',
        'runningbal',
        'datetimeadded',
        'addedby',
        'ipaddress',
        'partnerid',
        'transactionref',
        'approved'
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
        return FloatBalance::class;
    }
}
