<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="Role",
 *      required={""},
 *      @SWG\Property(
 *          property="roleid",
 *          description="roleid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="rolename",
 *          description="rolename",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="description",
 *          description="description",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="roletype",
 *          description="roletype",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="rolestatus",
 *          description="rolestatus",
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
class Role extends Model
{
    use SoftDeletes;

    public $table = 'tbl_sec_roles';
    public $primaryKey = 'roleid';
    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];
    public $timestamps = false;



    public $fillable = [
        'rolename',
        'description',
        'roletype',
        'rolestatus',
        'addedby',
        'ipaddress'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'roleid' => 'integer',
        'rolename' => 'string',
        'description' => 'string',
        'roletype' => 'string',
        'rolestatus' => 'string',
        'addedby' => 'integer',
        'ipaddress' => 'string'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'rolename' => 'required',
        'description' => 'required',
        'roletype' => 'required',
        'rolestatus' => 'required',
        'ipaddress' => 'required',
    ];
    public function user(){
    return $this->belongsTo(User::class, 'id', 'role_id');
    }


}
