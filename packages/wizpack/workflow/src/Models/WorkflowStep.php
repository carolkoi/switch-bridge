<?php

namespace WizPack\Workflow\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * @property int $id
 * @property int $workflow_stage_id
 * @property int $workflow_id
 * @property int $user_id
 * @property string $approved_at
 * @property string $rejected_at
 * @property int $weight
 * @property string $deleted_at
 * @property string $created_at
 * @property string $updated_at
 * @property WorkflowStage $workflowStage
 * @property Approvals $workflow
 * @property User $user
 * @property WorkflowStepChecklist[] $workflowStepChecklists
 */
class WorkflowStep extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'workflow_steps';

    /**
     * @var array
     */
    protected $fillable = ['workflow_stage_id', 'workflow_id', 'user_id', 'approved_at', 'rejected_at', 'weight', 'deleted_at', 'created_at', 'updated_at'];

    /**
     * @return BelongsTo
     */
    public function workflowStage()
    {
        return $this->belongsTo(WorkflowStage::class, 'workflow_stage_id', 'id');
    }

    /**
     * @return BelongsTo
     */
    public function workflow()
    {
        return $this->belongsTo(Approvals::class);
    }

    /**
     * @return BelongsTo
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * @return HasMany
     */
    public function workflowStepChecklists()
    {
        return $this->hasMany(WorkflowStepChecklist::class, 'workflow_steps_id');
    }

    public function scopeApprovalStages($query)
    {
        return $query->whereHas('workflowSteps', function ($q) {
            return $q->orderBy('weight', 'asc');
        });
    }
}
