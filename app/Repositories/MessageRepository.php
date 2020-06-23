<?php

namespace App\Repositories;

use App\Models\Message;
use App\Repositories\BaseRepository;

/**
 * Class MessageRepository
 * @package App\Repositories
 * @version June 22, 2020, 1:23 pm UTC
*/

class MessageRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'messagetypeid',
        'messageoutboxid',
        'mobilenumber',
        'messagelanguage',
        'message',
        'contents',
        'messagestatus',
        'datetimeadded',
        'addedby',
        'ipaddress',
        'source',
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
        return Message::class;
    }
}
