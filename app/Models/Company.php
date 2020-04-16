<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="Company",
 *      required={""},
 *      @SWG\Property(
 *          property="companyid",
 *          description="companyid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="companyname",
 *          description="companyname",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="companyaddress",
 *          description="companyaddress",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="companyemail",
 *          description="companyemail",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="contactperson",
 *          description="contactperson",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="companytype",
 *          description="companytype",
 *          type="string"
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
class Company extends Model
{
    use SoftDeletes;

    public $table = 'tbl_cmp_company';
    public $primaryKey = 'companyid';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];



    public $fillable = [
        'companyname',
        'companyaddress',
        'companyemail',
        'contactperson',
        'companytype',
        'addedby',
        'ipaddress'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'companyid' => 'integer',
        'companyname' => 'string',
        'companyaddress' => 'string',
        'companyemail' => 'string',
        'contactperson' => 'string',
        'companytype' => 'string',
        'addedby' => 'integer',
        'ipaddress' => 'string'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'companyname' => 'required',
        'companyaddress' => 'required',
        'companyemail' => 'required',
        'contactperson' => 'required',
        'companytype' => 'required',
        'addedby' => 'required',
        'ipaddress' => 'string'
    ];


}
