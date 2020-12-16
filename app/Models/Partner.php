<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Auth;

/**
 * @SWG\Definition(
 *      definition="Partner",
 *      required={"partner_idx"},
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
 *          property="partner_idx",
 *          description="partner_idx",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="partner_id",
 *          description="partner_id",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="setting_profile",
 *          description="setting_profile",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="partner_name",
 *          description="partner_name",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="partner_type",
 *          description="partner_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="partner_username",
 *          description="partner_username",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="partner_password",
 *          description="partner_password",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="partner_api_endpoint",
 *          description="partner_api_endpoint",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="allowed_transaction_types",
 *          description="allowed_transaction_types",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="unlock_time",
 *          description="unlock_time",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="lock_status",
 *          description="lock_status",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="partner_status",
 *          description="partner_status",
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
class
Partner extends Model
{
    use SoftDeletes;

    public $table = 'tbl_sys_partners';
    public $primaryKey = 'partner_id';
    public $incrementing = false;

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];



    public $fillable = [
        'date_time_added',
        'added_by',
        'date_time_modified',
        'modified_by',
        'partner_idx',
        'setting_profile',
        'partner_name',
        'partner_type',
        'partner_username',
        'partner_password',
        'partner_api_endpoint',
        'allowed_transaction_types',
        'unlock_time',
        'lock_status',
        'partner_status',
        'record_version',
        'company_id'
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
        'partner_idx' => 'integer',
        'partner_id' => 'string',
        'setting_profile' => 'string',
        'partner_name' => 'string',
        'partner_type' => 'string',
        'partner_username' => 'string',
        'partner_password' => 'string',
        'partner_api_endpoint' => 'string',
        'allowed_transaction_types' => 'string',
        'unlock_time' => 'integer',
        'lock_status' => 'string',
        'partner_status' => 'string',
        'record_version' => 'integer',
        'company_id' => 'integer'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'partner_idx' => 'required'
    ];

    public function company(){
       return $this->belongsTo(Company::class, 'company_id', 'companyid');
    }

    public function scopePartners($query){
        return $query->where('company_id', Auth::user()->company_id);
    }



}
