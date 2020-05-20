<?php

namespace App\Repositories;

use App\Models\ApiTransaction;
use App\Repositories\BaseRepository;

/**
 * Class ApiTransactionRepository
 * @package App\Repositories
 * @version May 20, 2020, 9:44 am UTC
*/

class ApiTransactionRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'date_time_added',
        'added_by',
        'date_time_modified',
        'modified_by',
        'user_activity_log_id',
        'source_ip',
        'latest_ip',
        'request_id',
        'request_number',
        'partner_id',
        'partner_name',
        'transaction_ref',
        'transaction_date',
        'collection_branch',
        'transaction_type',
        'service_type',
        'sender_type',
        'sender_full_name',
        'sender_address',
        'sender_city',
        'sender_country_code',
        'sender_currency_code',
        'sender_mobile',
        'send_amount',
        'sender_id_type',
        'sender_id_number',
        'receiver_type',
        'receiver_full_name',
        'receiver_country_code',
        'receiver_currency_code',
        'receiver_amount',
        'receiver_city',
        'receiver_address',
        'receiver_mobile',
        'mobile_operator',
        'receiver_id_type',
        'receiver_id_number',
        'receiver_account',
        'receiver_bank',
        'receiver_bank_code',
        'receiver_swiftcode',
        'receiver_branch',
        'receiver_branch_code',
        'exchange_rate',
        'commission_amount',
        'remarks',
        'paybill',
        'transaction_number',
        'transaction_hash',
        'transaction_status',
        'original_message',
        'transaction_response',
        'switch_response',
        'query_status',
        'query_response',
        'callbacks',
        'callbacks_status',
        'queued_callbacks',
        'completed_callbacks',
        'callback_status',
        'record_version',
        'need_syncing',
        'synced',
        'sent',
        'incident_code',
        'incident_description',
        'incident_note'
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
        return ApiTransaction::class;
    }
}
