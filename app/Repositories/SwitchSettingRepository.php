<?php

namespace App\Repositories;

use App\Models\SwitchSetting;
use App\Repositories\BaseRepository;

/**
 * Class SwitchSettingRepository
 * @package App\Repositories
 * @version April 4, 2020, 6:56 pm UTC
*/

class SwitchSettingRepository extends BaseRepository
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
        'setting_name',
        'setting_value',
        'setting_type',
        'setting_status',
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
        return SwitchSetting::class;
    }
}
