<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="Setting",
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
 *          property="setting_id",
 *          description="setting_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="setting_profile",
 *          description="setting_profile",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="setting_name",
 *          description="setting_name",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="setting_value",
 *          description="setting_value",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="setting_type",
 *          description="setting_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="setting_status",
 *          description="setting_status",
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
class Setting extends Model
{
    use SoftDeletes;

    public $table = 'tbl_sys_settings';
    
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
        'setting_name',
        'setting_value',
        'setting_type',
        'setting_status',
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
        'setting_id' => 'integer',
        'setting_profile' => 'string',
        'setting_name' => 'string',
        'setting_value' => 'string',
        'setting_type' => 'string',
        'setting_status' => 'string',
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
