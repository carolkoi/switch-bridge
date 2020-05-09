<?php

namespace WizPack\Workflow\Models;


use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use WizPack\Workflow\Models\Scopes\WeightScope;

/**
 * @SWG\Definition(
 *      definition="WorkflowStages",
 *      required={""},
 *      @SWG\Property(
 *          property="id",
 *          description="id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="workflow_stage_type_id",
 *          description="workflow_stage_type_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="workflow_type_id",
 *          description="workflow_type_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="weight",
 *          description="weight",
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
class WorkflowStage extends Model
{
//    use SoftDeletes;

    public $table = 'workflow_stages';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];


    public $fillable = [
        'workflow_stage_type_id',
        'workflow_type_id',
        'weight'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'id' => 'integer',
        'workflow_stage_type_id' => 'integer',
        'workflow_type_id' => 'integer',
        'weight' => 'integer'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'workflow_stage_type_id' => 'required|exists:workflow_stage_type,id',
        'workflow_type_id' => 'required|exists:workflow_types,id',
        'weight' => 'required|integer'
    ];


    /**
     *global scope to order workflow stages by their weight
     */
    protected static function boot()
    {
        parent::boot();

        $self = new self();

        static::addGlobalScope(new WeightScope($self->table));
    }

    /**
     * @return BelongsTo
     **/
    public function workflowStageType()
    {
        return $this->belongsTo(WorkflowStageType::class, 'workflow_stage_type_id');
    }

    /**
     * @return BelongsTo
     **/
    public function workflowType()
    {
        return $this->belongsTo(WorkflowType::class, 'workflow_type_id');
    }

    /**
     * @return HasMany
     **/
    public function workflowApprovers()
    {
        return $this->hasMany(WorkflowApprover::class, 'workflow_stage_id');
    }

    /**
     * @return HasMany
     **/
    public function workflowStageChecklists()
    {
        return $this->hasMany(WorkflowStageChecklist::class, 'workflow_stages_id');
    }

    /**
     * @return HasMany
     **/
    public function workflowSteps()
    {
        return $this->hasMany(WorkflowStep::class, 'workflow_stage_id');
    }

    /**
     * @return HasMany
     **/
    public function workflows()
    {
        return $this->hasMany(Approvals::class, 'awaiting_stage_id');
    }
}
