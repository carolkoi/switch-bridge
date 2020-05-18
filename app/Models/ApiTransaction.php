<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="ApiTransaction",
 *      required={""},
 *      @SWG\Property(
 *          property="date_time_added",
 *          description="date_time_added",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="added_by",
 *          description="added_by",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="date_time_modified",
 *          description="date_time_modified",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="modified_by",
 *          description="modified_by",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="user_activity_log_id",
 *          description="user_activity_log_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="source_ip",
 *          description="source_ip",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="latest_ip",
 *          description="latest_ip",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="transaction_id",
 *          description="transaction_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="request_id",
 *          description="request_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="request_number",
 *          description="request_number",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="partner_id",
 *          description="partner_id",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="partner_name",
 *          description="partner_name",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="transaction_ref",
 *          description="transaction_ref",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="transaction_date",
 *          description="transaction_date",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="collection_branch",
 *          description="collection_branch",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="transaction_type",
 *          description="transaction_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="service_type",
 *          description="service_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="sender_type",
 *          description="sender_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="sender_full_name",
 *          description="sender_full_name",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="sender_address",
 *          description="sender_address",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="sender_city",
 *          description="sender_city",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="sender_country_code",
 *          description="sender_country_code",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="sender_currency_code",
 *          description="sender_currency_code",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="sender_mobile",
 *          description="sender_mobile",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="send_amount",
 *          description="send_amount",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="sender_id_type",
 *          description="sender_id_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="sender_id_number",
 *          description="sender_id_number",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_type",
 *          description="receiver_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_full_name",
 *          description="receiver_full_name",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_country_code",
 *          description="receiver_country_code",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_currency_code",
 *          description="receiver_currency_code",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_amount",
 *          description="receiver_amount",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="receiver_city",
 *          description="receiver_city",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_address",
 *          description="receiver_address",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_mobile",
 *          description="receiver_mobile",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="mobile_operator",
 *          description="mobile_operator",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_id_type",
 *          description="receiver_id_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_id_number",
 *          description="receiver_id_number",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_account",
 *          description="receiver_account",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_bank",
 *          description="receiver_bank",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_bank_code",
 *          description="receiver_bank_code",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_swiftcode",
 *          description="receiver_swiftcode",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_branch",
 *          description="receiver_branch",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="receiver_branch_code",
 *          description="receiver_branch_code",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="exchange_rate",
 *          description="exchange_rate",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="commission_amount",
 *          description="commission_amount",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="remarks",
 *          description="remarks",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="paybill",
 *          description="paybill",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="transaction_number",
 *          description="transaction_number",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="transaction_hash",
 *          description="transaction_hash",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="transaction_status",
 *          description="transaction_status",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="original_message",
 *          description="original_message",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="transaction_response",
 *          description="transaction_response",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="switch_response",
 *          description="switch_response",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="query_status",
 *          description="query_status",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="query_response",
 *          description="query_response",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="callbacks",
 *          description="callbacks",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="callbacks_status",
 *          description="callbacks_status",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="queued_callbacks",
 *          description="queued_callbacks",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="completed_callbacks",
 *          description="completed_callbacks",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="callback_status",
 *          description="callback_status",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="record_version",
 *          description="record_version",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="need_syncing",
 *          description="need_syncing",
 *          type="boolean"
 *      ),
 *      @SWG\Property(
 *          property="synced",
 *          description="synced",
 *          type="boolean"
 *      ),
 *      @SWG\Property(
 *          property="sent",
 *          description="sent",
 *          type="boolean"
 *      ),
 *      @SWG\Property(
 *          property="incident_code",
 *          description="incident_code",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="incident_description",
 *          description="incident_description",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="incident_note",
 *          description="incident_note",
 *          type="string"
 *      )
 * )
 */
class ApiTransaction extends Model
{
    use SoftDeletes;

    public $table = 'tbl_trn_transactions';
    
    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];



    public $fillable = [
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
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'date_time_added' => 'integer',
        'added_by' => 'integer',
        'date_time_modified' => 'integer',
        'modified_by' => 'integer',
        'user_activity_log_id' => 'integer',
        'source_ip' => 'string',
        'latest_ip' => 'string',
        'transaction_id' => 'integer',
        'request_id' => 'integer',
        'request_number' => 'string',
        'partner_id' => 'string',
        'partner_name' => 'string',
        'transaction_ref' => 'string',
        'transaction_date' => 'string',
        'collection_branch' => 'string',
        'transaction_type' => 'string',
        'service_type' => 'string',
        'sender_type' => 'string',
        'sender_full_name' => 'string',
        'sender_address' => 'string',
        'sender_city' => 'string',
        'sender_country_code' => 'string',
        'sender_currency_code' => 'string',
        'sender_mobile' => 'string',
        'send_amount' => 'float',
        'sender_id_type' => 'string',
        'sender_id_number' => 'string',
        'receiver_type' => 'string',
        'receiver_full_name' => 'string',
        'receiver_country_code' => 'string',
        'receiver_currency_code' => 'string',
        'receiver_amount' => 'float',
        'receiver_city' => 'string',
        'receiver_address' => 'string',
        'receiver_mobile' => 'string',
        'mobile_operator' => 'string',
        'receiver_id_type' => 'string',
        'receiver_id_number' => 'string',
        'receiver_account' => 'string',
        'receiver_bank' => 'string',
        'receiver_bank_code' => 'string',
        'receiver_swiftcode' => 'string',
        'receiver_branch' => 'string',
        'receiver_branch_code' => 'string',
        'exchange_rate' => 'float',
        'commission_amount' => 'float',
        'remarks' => 'string',
        'paybill' => 'string',
        'transaction_number' => 'string',
        'transaction_hash' => 'string',
        'transaction_status' => 'string',
        'original_message' => 'string',
        'transaction_response' => 'string',
        'switch_response' => 'string',
        'query_status' => 'string',
        'query_response' => 'string',
        'callbacks' => 'string',
        'callbacks_status' => 'string',
        'queued_callbacks' => 'integer',
        'completed_callbacks' => 'integer',
        'callback_status' => 'integer',
        'record_version' => 'integer',
        'need_syncing' => 'boolean',
        'synced' => 'boolean',
        'sent' => 'boolean',
        'incident_code' => 'string',
        'incident_description' => 'string',
        'incident_note' => 'string'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        
    ];

    
}
