<?php

namespace App\Models;

use App\Response;
use App\User;
use Carbon\Carbon;
use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use WizPack\Workflow\Interfaces\ApprovableInterface;
use WizPack\Workflow\Traits\ApprovableTrait;

class Template extends Model implements ApprovableInterface
{
    use SoftDeletes,ApprovableTrait;

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
        'valid_from',
        'valid_until',
        'email_msg',
        'approved',
        'rejected'

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

    /**
     * a link to view the approval details i.e. a link to show in your controller
     * method to be defined on the model
     *
     * @return mixed
     */
    public function previewLink()
    {
        return env('APP_URL')."/allocations";
    }

    /**
     * marking the approval as complete
     * @param $id
     */
    public function markApprovalComplete($id)
    {
        $model = self::find($id);
        $model->approved = 1;
        $model->approved_at = Carbon::now();
        $model->save();
    }

    /**
     * marking the approval as rejected
     * @param $id
     */
    public function markApprovalAsRejected($id)
    {
        $model = self::find($id);
        $model->rejected = 1;
        $model->rejected_at = Carbon::now();
        $model->save();
    }
}
