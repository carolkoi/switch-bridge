<?php

namespace App\Models;

use App\Response;
use App\User;
use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Template extends Model
{
    use SoftDeletes;

    public $table = 'templates';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';
    const ACTIVE = true;


    protected $dates = ['deleted_at'];



    public $fillable = [
        'type',
        'name',
        'description',
        'status',
        'valid_from',
        'valid_until',
        'email_msg',
        'user_id'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'id' => 'integer',
        'type' => 'string',
        'name' => 'string',
        'description' => 'string',
        'status' => 'boolean',
        'valid_from' => 'date',
        'valid_until' => 'date',
        'email_msg' => 'string'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'name' => 'required',
        'description' => 'required',
        'valid_from' => 'required',
        'valid_until' => 'required',
        'email_msg' => 'required'
    ];

    public function user()
    {
        return $this->belongsTo(User::class,'user_id');
    }
    public function questions()
    {
        return $this->hasMany(Question::class);
    }

    public function allocations()
    {
        return $this->hasMany(Allocation::class);
    }
//    public static function boot()
//    {
//        parent::boot();
//        self::creating(function ($model) {
//            $model->uuid = (string) Uuid::generate(4);
//        });
//    }


}
