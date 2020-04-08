<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="AML-Checker",
 *      required={""},
 *      @SWG\Property(
 *          property="date_time_added",
 *          description="date_time_added",
 *          type="number",
 *          format="number"
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
 *          type="number",
 *          format="number"
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
 *          property="blacklist_id",
 *          description="blacklist_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="partner_id",
 *          description="partner_id",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="customer_idnumber",
 *          description="customer_idnumber",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="transaction_number",
 *          description="transaction_number",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="customer_name",
 *          description="customer_name",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="mobile_number",
 *          description="mobile_number",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="blacklist_status",
 *          description="blacklist_status",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="response",
 *          description="response",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="blacklist_source",
 *          description="blacklist_source",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="remarks",
 *          description="remarks",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="blacklisted",
 *          description="blacklisted",
 *          type="boolean"
 *      ),
 *      @SWG\Property(
 *          property="blacklist_version",
 *          description="blacklist_version",
 *          type="integer",
 *          format="int32"
 *      )
 * )
 */
class AML-Checker extends Model
{
    use SoftDeletes;

    public $table = 'tbl_cus_blacklist';
    
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
        'partner_id',
        'customer_idnumber',
        'transaction_number',
        'customer_name',
        'mobile_number',
        'blacklist_status',
        'response',
        'blacklist_source',
        'remarks',
        'blacklisted',
        'blacklist_version'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'date_time_added' => 'float',
        'added_by' => 'integer',
        'date_time_modified' => 'float',
        'modified_by' => 'integer',
        'source_ip' => 'string',
        'latest_ip' => 'string',
        'blacklist_id' => 'integer',
        'partner_id' => 'string',
        'customer_idnumber' => 'string',
        'transaction_number' => 'string',
        'customer_name' => 'string',
        'mobile_number' => 'string',
        'blacklist_status' => 'string',
        'response' => 'string',
        'blacklist_source' => 'string',
        'remarks' => 'string',
        'blacklisted' => 'boolean',
        'blacklist_version' => 'integer'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        
    ];

    
}
