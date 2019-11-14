<?php

namespace App\Models;

use App\Question;
//use App\Template;
use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="Response",
 *      required={""},
 *      @SWG\Property(
 *          property="id",
 *          description="id",
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
 *          property="client_id",
 *          description="client_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="template_id",
 *          description="template_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="question_id",
 *          description="question_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="answer_type",
 *          description="answer_type",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="answer",
 *          description="answer",
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
class Response extends Model
{
    use SoftDeletes;

    public $table = 'responses';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];



    public $fillable = [
        'user_id',
        'client_id',
        'template_id',
        'question_id',
        'answer_type',
        'answer',
        'survey_uuid'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'id' => 'integer',
        'user_id' => 'integer',
        'client_id' => 'integer',
        'template_id' => 'integer',
        'question_id' => 'integer',
        'answer_type' => 'integer',
        'answer' => 'string',
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'template_id' => 'required',
        'question_id' => 'required',
        'answer_type' => 'required',
        'answer' => 'required',
        'survey_uuid' => 'required|unique:responses'

    ];

    public function template()
    {
        return $this->belongsTo(Template::class);
    }

    public function question()
    {
        return $this->belongsTo(Question::class);
    }

    public function allocations()
    {
        return $this->hasManyThrough('App\Models\Allocation', 'App\Models\Template', 'id');
    }

    public function scopecountRespondentsByTemplateId($query, $template_id, $question_id){
        return $query->where(['template_id' =>$template_id, 'question_id' => $question_id])->count();
    }

}
