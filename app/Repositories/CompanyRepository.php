<?php

namespace App\Repositories;

use App\Models\Company;
use App\Repositories\BaseRepository;

/**
 * Class CompanyRepository
 * @package App\Repositories
 * @version April 4, 2020, 7:08 pm UTC
*/

class CompanyRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'companyname',
        'companyaddress',
        'companyemail',
        'contactperson',
        'companytype',
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
        return Company::class;
    }
}
