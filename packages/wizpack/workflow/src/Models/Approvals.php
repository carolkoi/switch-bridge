<?php

namespace WizPack\Workflow\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @property mixed workflowSteps
 * @SWG\Definition(
 *      definition="Approvals",
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
 *          property="workflow_type",
 *          description="workflow_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="model_id",
 *          description="model_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="model_type",
 *          description="model_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="collection_name",
 *          description="collection_name",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="payload",
 *          description="payload",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="sent_by",
 *          description="sent_by",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="approved",
 *          description="approved",
 *          type="boolean"
 *      ),
 *      @SWG\Property(
 *          property="approved_on",
 *          description="approved_on",
 *          type="string",
 *          format="date-time"
 *      ),
 *      @SWG\Property(
 *          property="awaiting_stage_id",
 *          description="awaiting_stage_id",
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
class Approvals extends Model
{
    use SoftDeletes;

    public $table = 'workflows';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];


    public $fillable = [
        'user_id',
        'workflow_type',
        'model_id',
        'model_type',
        'collection_name',
        'payload',
        'sent_by',
        'approved',
        'approved_at',
        'rejected_at',
        'awaiting_stage_id'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'id' => 'integer',
        'user_id' => 'integer',
        'workflow_type' => 'string',
        'model_id' => 'integer',
        'model_type' => 'string',
        'collection_name' => 'string',
        'payload' => 'string',
        'sent_by' => 'integer',
        'approved' => 'boolean',
        'approved_at'=> 'datetime',
        'rejected_at'=> 'datetime',
        'awaiting_stage_id' => 'integer'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'user_id' => 'required|exists:users,id',
        'workflow_type' => 'required',
        'sent_by' => 'required',
        'awaiting_stage_id' => 'required'
    ];

    /**
     * @return BelongsTo
     **/
    public function awaitingStage()
    {
        return $this->belongsTo(WorkflowStage::class, 'awaiting_stage_id', 'id');
    }

    /**
     * @return BelongsTo
     **/
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * @return BelongsTo
     **/
    public function sentBy()
    {
        return $this->belongsTo(User::class, 'sent_by');
    }

    /**
     * @return HasMany
     **/
    public function workflowSteps()
    {
        return $this->hasMany(WorkflowStep::class, 'workflow_id');
    }

    /**
     * Get all of the owning approvable models.
     */
    public function approvable()
    {
        return $this->morphTo('approvable', 'model_type', 'model_id', 'id');
    }

    public function workflow()
    {
        return $this->belongsTo(WorkflowType::class, 'workflow_type', 'slug');
    }

    public function scopeMyApprovals($query, $userId = null)
    {
        $userId = $userId ?: auth()->id();

        $query->whereHas('workflow.workflowStages.workflowApprovers', function ($q) use ($userId) {
            return $q->where('user_id', $userId);
        })->orWhereHas('workflow', function ($q) use ($userId) {
            return $q->where('sent_by', $userId);
        })->latest();
    }

    public function scopeApprovalSteps($query)
    {
        return $query->whereHas('workflowSteps', function ($q) {
            return $q->orderBy('weight', 'asc');
        });
    }

    public function scopeApprovalStages($query)
    {
        return $query->whereHas('workflowSteps.workflowStage', function ($q) {
            return $q->orderBy('weight', 'asc');
        });
    }

    public function approvalStatus()
    {
        if (!empty($this->approved_at)) {
            return '<span class="label label-success">Approved</span>';
        }

        if (!empty($this->rejected_at)) {
            return '<span class="label label-danger">Rejected</span>';
        }

        return '<span class="label label-primary">Pending</span>';

    }
}
