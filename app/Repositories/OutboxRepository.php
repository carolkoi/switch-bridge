<?php

namespace App\Repositories;

use App\Models\Outbox;
use App\Repositories\BaseRepository;

/**
 * Class OutboxRepository
 * @package App\Repositories
 * @version June 22, 2020, 1:24 pm UTC
*/

class OutboxRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'messageid',
        'messagetypeid',
        'messagestatus',
        'messagepriority',
        'datetimesent',
        'datetimeadded',
        'addedby',
        'ipaddress',
        'attempts',
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
        return Outbox::class;
    }
}
