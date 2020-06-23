<?php

namespace App\Repositories;

use App\Models\MessageTemplate;
use App\Repositories\BaseRepository;

/**
 * Class MessageTemplateRepository
 * @package App\Repositories
 * @version June 22, 2020, 11:17 am UTC
*/

class MessageTemplateRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'messagetype',
        'eng_message',
        'kis_message',
        'messagepriority',
        'datetimeadded',
        'addedby',
        'ipaddress',
        'partnerid',
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
        return MessageTemplate::class;
    }
}
