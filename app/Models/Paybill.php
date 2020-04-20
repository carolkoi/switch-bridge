<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="Paybill",
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
 *          property="paybill_id",
 *          description="paybill_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="setting_profile",
 *          description="setting_profile",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="paybill_type",
 *          description="paybill_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="api_application_name",
 *          description="api_application_name",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="api_consumer_key",
 *          description="api_consumer_key",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="api_consumer_secret",
 *          description="api_consumer_secret",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="api_consumer_code",
 *          description="api_consumer_code",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="api_endpoint",
 *          description="api_endpoint",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="api_host",
 *          description="api_host",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="shortcode",
 *          description="shortcode",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="partnercode",
 *          description="partnercode",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="paybill_status",
 *          description="paybill_status",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="record_version",
 *          description="record_version",
 *          type="integer",
 *          format="int32"
 *      )
 * )
 */
class Paybill extends Model
{
    use SoftDeletes;

    public $table = 'tbl_sys_paybills';
    
    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];



    public $fillable = [
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
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'date_time_added' => 'integer',
        'added_by' => 'integer',
        'date_time_modified' => 'integer',
        'modified_by' => 'integer',
        'source_ip' => 'string',
        'latest_ip' => 'string',
        'paybill_id' => 'integer',
        'setting_profile' => 'string',
        'paybill_type' => 'string',
        'api_application_name' => 'string',
        'api_consumer_key' => 'string',
        'api_consumer_secret' => 'string',
        'api_consumer_code' => 'string',
        'api_endpoint' => 'string',
        'api_host' => 'string',
        'shortcode' => 'string',
        'partnercode' => 'string',
        'paybill_status' => 'string',
        'record_version' => 'integer'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        
    ];

    
}
