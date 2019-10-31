<?php

namespace App\Models;

use App\Template;
use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Question extends Model
{
    use SoftDeletes;

    public $table = 'questions';

    const ACTIVE = true;

    const USER_INPUT = 1;
    const SELECT_ONE = 2;
    const SELECT_MULTIPLE = 3;
    const DATE = 4;
    const NUMBER = 5;
    const DROP_DOWN_LIST = 6;

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];



    public $fillable = [
        'template_id',
        'question',
        'type',
        'answer_id',
        'status',
        'description'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'id' => 'integer',
        'template_id' => 'integer',
        'question' => 'string',
        'type' => 'integer',
        'answer_id' => 'integer',
        'status' => 'boolean',
        'description' => 'string'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'template_id' => 'required',
        'question' => 'required|unique:questions',
        'type' => 'required',
//        'status' => 'required'
    ];

    public function scopeByTemplateId($query, $template_id){
        return $query->where('template_id',$template_id)->count();
    }
    public function template()
    {
        return $this->belongsTo(Template::class, 'template_id');
    }

    public static function Bytemplate($id)
    {
        return self::where('template_id',$id);
    }
    public function answer()
    {
        return $this->hasMany(Answer::class);
    }
    public function responses()
    {
        return $this->hasMany(Response::class);
    }

}
