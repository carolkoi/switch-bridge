<?php

namespace App\Repositories;

use App\Models\Provider;
use App\Repositories\BaseRepository;

/**
 * Class ProviderRepository
 * @package App\Repositories
 * @version April 4, 2020, 7:12 pm UTC
*/

class ProviderRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'companyid',
        'moneyservicename',
        'provideridentifier',
        'accountnumber',
        'serviceprovidercategoryid',
        'cutofflimit',
        'settlementaccount',
        'b2cbalance',
        'c2bbalance',
        'processingmode',
        'addedby',
        'serviceprovidertype',
        'status'
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
        return Provider::class;
    }
}
