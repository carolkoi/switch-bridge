<?php

namespace App\Repositories;

use App\Models\Comp;
use App\Repositories\BaseRepository;

/**
 * Class CompRepository
 * @package App\Repositories
 * @version April 19, 2020, 10:19 pm UTC
*/

class CompRepository extends BaseRepository
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
        return Comp::class;
    }
}
