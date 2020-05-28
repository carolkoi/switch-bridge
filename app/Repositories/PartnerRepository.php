<?php

namespace App\Repositories;

use App\Models\Partner;
use App\Repositories\BaseRepository;

/**
 * Class PartnerRepository
 * @package App\Repositories
 * @version May 28, 2020, 9:44 am UTC
*/

class PartnerRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'date_time_added',
        'added_by',
        'date_time_modified',
        'modified_by',
        'partner_idx',
        'setting_profile',
        'partner_name',
        'partner_type',
        'partner_username',
        'partner_password',
        'partner_api_endpoint',
        'allowed_transaction_types',
        'unlock_time',
        'lock_status',
        'partner_status',
        'record_version'
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
        return Partner::class;
    }
}
