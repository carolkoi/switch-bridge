<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="Float",
 *      required={""},
 *      @SWG\Property(
 *          property="floattransactionid",
 *          description="floattransactionid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="partnerid",
 *          description="partnerid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="description",
 *          description="description",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="transactionnumber",
 *          description="transactionnumber",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="debit",
 *          description="debit",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="credit",
 *          description="credit",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="amount",
 *          description="amount",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="runningbal",
 *          description="runningbal",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="datetimeadded",
 *          description="datetimeadded",
 *          type="string",
 *          format="date-time"
 *      ),
 *      @SWG\Property(
 *          property="addedby",
 *          description="addedby",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="ipaddress",
 *          description="ipaddress",
 *          type="string"
 *      )
 * )
 */
class Float extends Model
{
    use SoftDeletes;

    public $table = 'tbl_floattransactions';
    
    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];



    public $fillable = [
        'partnerid',
        'description',
        'transactionnumber',
        'debit',
        'credit',
        'amount',
        'runningbal',
        'datetimeadded',
        'addedby',
        'ipaddress'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'floattransactionid' => 'integer',
        'partnerid' => 'integer',
        'description' => 'string',
        'transactionnumber' => 'string',
        'debit' => 'decimal:0',
        'credit' => 'decimal:0',
        'amount' => 'decimal:0',
        'runningbal' => 'decimal:0',
        'datetimeadded' => 'datetime',
        'addedby' => 'integer',
        'ipaddress' => 'string'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        
    ];

    
}
