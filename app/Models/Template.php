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
    const APPROVED = true;


    protected $dates = ['deleted_at'];



    public $fillable = [
        'user_id',
        'survey_type_id',
        'name',
        'description',
        'status',
        'valid_from',
        'valid_until',
        'email_msg',

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

    public function scopecountSurveyType($query, $type){
        return $query->where(['type'=> $type])->count();
    }
    public function responses(){
        return $this->hasManyThrough('App\Models\Response', 'App\Models\Question', 'template_id');
    }

    public function surveyType(){
        return $this->belongsTo(SurveyType::class, 'survey_type_id');
    }

    public function surveyUuids(){
        return $this->hasMany(SentSurveys::class);
    }
}
