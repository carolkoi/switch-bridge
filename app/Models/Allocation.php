<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use WizPack\Workflow\Interfaces\ApprovableInterface;
use WizPack\Workflow\Traits\ApprovableTrait;


/**
 * @SWG\Definition(
 *      definition="Allocation",
 *      required={""},
 *      @SWG\Property(
 *          property="id",
 *          description="id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="user_type",
 *          description="user_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="client_id",
 *          description="client_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="user_id",
 *          description="user_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="type",
 *          description="type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="template_id",
 *          description="template_id",
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
 *      ),
 *      @SWG\Property(
 *          property="deleted_at",
 *          description="deleted_at",
 *          type="string",
 *          format="date-time"
 *      )
 * )
 */
class Allocation extends Model
{
//    use SoftDeletes;

    public $table = 'allocations';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';
    const APPROVED = true;


    protected $dates = ['deleted_at'];



    public $fillable = [
        'user_type',
        'client_id',
        'user_id',
        'others',
        'type',
        'status',
        'approved',
        'template_id'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'id' => 'integer',
        'user_type' => 'string',
        'client_id' => 'integer',
        'user_id' => 'integer',
        'type' => 'string',
        'status' => 'boolean',
        'template_id' => 'integer'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'template_id' => 'required'
    ];

    public function template()
    {
        return $this->belongsTo(Template::class, 'template_id','id');
    }
    public function user(){
        return $this->belongsTo(User::class, 'user_id','id');
    }

    public function client(){
        return $this->belongsTo(Client::class, 'client_id', 'id');
    }

    public function scopeCountUsersByTemplateId($query, $template_id, $user_type){
        return $query->where(['template_id' =>$template_id, 'user_type' => $user_type])->count();
    }

    public function scopeCountAllUsersByTemplateId($query, $template_id){
        return $query->where(['template_id' => $template_id])->count();
    }

//    public function users(){
//        return $this->belongsToMany('App\Models\User', 'allocation_user', 'allocation_id', 'user_id');
//    }
//
//    public function clients(){
//        return $this->belongsToMany('App\Models\Client', 'allocation_client', 'allocation_id', 'client_id');
//    }
}
