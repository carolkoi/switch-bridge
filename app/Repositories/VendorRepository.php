<?php

namespace App\Repositories;

use App\Models\Vendor;
use App\Repositories\BaseRepository;

/**
 * Class VendorRepository
 * @package App\Repositories
 * @version December 19, 2019, 1:18 pm UTC
*/

class VendorRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'account',
        'name',
        'contact_person',
        'physical1',
        'physical2',
        'physical3',
        'physical4',
        'physical5',
        'post1',
        'post2',
        'post3',
        'post4',
        'post5',
        'tax_number',
        'email'
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
        return Vendor::class;
    }
}
