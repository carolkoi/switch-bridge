<?php

namespace App\Repositories;

use App\Models\Paybill;
use App\Repositories\BaseRepository;

/**
 * Class PaybillRepository
 * @package App\Repositories
 * @version April 19, 2020, 9:16 pm UTC
*/

class PaybillRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'date_time_added',
        'added_by',
        'date_time_modified',
        'modified_by',
        'source_ip',
        'latest_ip',
        'setting_profile',
        'paybill_type',
        'api_application_name',
        'api_consumer_key',
        'api_consumer_secret',
        'api_consumer_code',
        'api_endpoint',
        'api_host',
        'shortcode',
        'partnercode',
        'paybill_status',
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
        return Paybill::class;
    }
}
