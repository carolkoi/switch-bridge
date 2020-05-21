<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\MorphToMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Permission\Traits\HasRoles;

/**
 * @SWG\Definition(
 *      definition="User",
 *      required={""},
 *      @SWG\Property(
 *          property="id",
 *          description="id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="company_id",
 *          description="company_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="role_id",
 *          description="role_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="name",
 *          description="name",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="contact_person",
 *          description="contact_person",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="email",
 *          description="email",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="password",
 *          description="password",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="msisdn",
 *          description="msisdn",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="status",
 *          description="status",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="remember_token",
 *          description="remember_token",
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
class User extends Authenticatable
{
    use SoftDeletes, HasRoles;

    public $table = 'users';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';
    protected $guard_name = 'web';


    protected $dates = ['deleted_at'];



    public $fillable = [
        'company_id',
        'role_id',
        'name',
        'contact_person',
        'email',
        'password',
        'msisdn',
        'status',
        'remember_token'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'id' => 'integer',
        'company_id' => 'integer',
        'role_id' => 'integer',
        'name' => 'string',
        'contact_person' => 'string',
        'email' => 'string',
        'password' => 'string',
        'msisdn' => 'integer',
        'status' => 'string',
        'remember_token' => 'string'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'company_id' => 'required',
        'role_id' => 'required',
        'name' => 'required',
        'contact_person' => 'required',
        'email' => 'required',
//        'password' => 'required',
        'msisdn' => 'required',
    ];

    public function company(){
    return $this->belongsTo(Company::class, 'company_id', 'companyid');
    }

//    public function roles(): BelongsToMany
//    {
//        return $this->belongsToMany(
//            config('permission.models.permission'),
//            config('permission.table_names.role_has_permissions'),
//            'role_id',
//            'permission_id'
//        );
//    }
//    public function roles(): MorphToMany
//    {
//        return $this->morphedByMany(
////            getModelForGuard($this->attributes['guard_name']),
//            '\Spatie\Permission\Models\Role',
//            config('permission.table_names.model_has_roles'),
//            'model_id',
//            config('permission.column_names.model_morph_key')
//        );
//    }


}
