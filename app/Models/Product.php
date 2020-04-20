<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="Product",
 *      required={""},
 *      @SWG\Property(
 *          property="productid",
 *          description="productid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="serviceproviderid",
 *          description="serviceproviderid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="product",
 *          description="product",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="productcode",
 *          description="productcode",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="description",
 *          description="description",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="charges",
 *          description="charges",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="commission",
 *          description="commission",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="transactiontype",
 *          description="transactiontype",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="status",
 *          description="status",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="addedby",
 *          description="addedby",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="modifiedby",
 *          description="modifiedby",
 *          type="integer",
 *          format="int32"
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
 *      )
 * )
 */
class Product extends Model
{
    use SoftDeletes;

    public $table = 'tbl_cmp_product';
    
    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];



    public $fillable = [
        'serviceproviderid',
        'product',
        'productcode',
        'description',
        'charges',
        'commission',
        'transactiontype',
        'status',
        'addedby',
        'modifiedby'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'productid' => 'integer',
        'serviceproviderid' => 'integer',
        'product' => 'string',
        'productcode' => 'string',
        'description' => 'string',
        'charges' => 'float',
        'commission' => 'float',
        'transactiontype' => 'string',
        'status' => 'string',
        'addedby' => 'integer',
        'modifiedby' => 'integer'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'serviceproviderid' => 'required',
        'product' => 'required',
        'productcode' => 'required',
        'description' => 'required',
        'charges' => 'required',
        'commission' => 'required',
        'transactiontype' => 'required',
        'status' => 'required',
        'addedby' => 'required',
        'modifiedby' => 'required',
        'created_at' => 'required',
        'updated_at' => 'required'
    ];

    
}
