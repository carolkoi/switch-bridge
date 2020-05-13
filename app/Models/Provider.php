<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="Provider",
 *      required={""},
 *      @SWG\Property(
 *          property="serviceproviderid",
 *          description="serviceproviderid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="companyid",
 *          description="companyid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="moneyservicename",
 *          description="moneyservicename",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="provideridentifier",
 *          description="provideridentifier",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="accountnumber",
 *          description="accountnumber",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="serviceprovidercategoryid",
 *          description="serviceprovidercategoryid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="cutofflimit",
 *          description="cutofflimit",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="settlementaccount",
 *          description="settlementaccount",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="b2cbalance",
 *          description="b2cbalance",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="c2bbalance",
 *          description="c2bbalance",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="processingmode",
 *          description="processingmode",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="addedby",
 *          description="addedby",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="serviceprovidertype",
 *          description="serviceprovidertype",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="status",
 *          description="status",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="created_at",
 *          description="created_at",
 *          type="string",
 *          format="date-time"
 *      ),
 *      @SWG\Property(
 *          property="updated_at",
 *          description="updated_at",
 *          type="string",
 *          format="date-time"
 *      ),
 *      @SWG\Property(
 *          property="deleted_at",
 *          description="deleted_at",
 *          type="string",
 *          format="date-time"
 *      )
 * )
 */
class Provider extends Model
{
    use SoftDeletes;

    public $table = 'tbl_pvd_serviceprovider';
    
    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];



    public $fillable = [
        'companyid',
        'moneyservicename',
        'provideridentifier',
        'accountnumber',
        'serviceprovidercategoryid',
        'cutofflimit',
        'settlementaccount',
        'b2cbalance',
        'c2bbalance',
        'processingmode',
        'addedby',
        'serviceprovidertype',
        'status'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'serviceproviderid' => 'integer',
        'companyid' => 'integer',
        'moneyservicename' => 'string',
        'provideridentifier' => 'integer',
        'accountnumber' => 'string',
        'serviceprovidercategoryid' => 'integer',
        'cutofflimit' => 'float',
        'settlementaccount' => 'string',
        'b2cbalance' => 'float',
        'c2bbalance' => 'float',
        'processingmode' => 'string',
        'addedby' => 'integer',
        'serviceprovidertype' => 'string',
        'status' => 'string'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'companyid' => 'required',
        'moneyservicename' => 'required',
        'provideridentifier' => 'required',
        'accountnumber' => 'required',
        'serviceprovidercategoryid' => 'required',
        'cutofflimit' => 'required',
        'settlementaccount' => 'required',
        'b2cbalance' => 'required',
        'c2bbalance' => 'required',
        'processingmode' => 'required',
        'addedby' => 'required',
        'serviceprovidertype' => 'required',
        'status' => 'required',
        'created_at' => 'required',
        'updated_at' => 'required'
    ];

    
}
