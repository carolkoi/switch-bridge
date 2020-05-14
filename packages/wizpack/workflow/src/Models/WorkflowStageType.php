<?php

namespace WizPack\Workflow\Models;

use WizPack\Workflow\Models\Scopes\WeightScope;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="WorkflowStageTypes",
 *      required={""},
 *      @SWG\Property(
 *          property="id",
 *          description="id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="name",
 *          description="name",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="slug",
 *          description="slug",
 *          type="string"
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
class WorkflowStageType extends Model
{
//    use SoftDeletes;

    public $table = 'workflow_stage_type';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];


    public $fillable = [
        'name',
        'slug',
        'weight'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'id' => 'integer',
        'name' => 'string',
        'slug' => 'string',
        'weight' => 'integer'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'name' => 'required|string',
//        'weight' => 'required|integer',
//        'slug' => 'required|bail|string|unique:workflow_stage_type,slug'
    ];

    /**
     *
     *global scope to order workflow stages by their weight
     *
     */
    protected static function boot()
    {
        parent::boot();

        $self = new self();

        static::addGlobalScope(new WeightScope($self->table));
    }

    /**
     * @return HasMany
     **/
    public function workflowApprovers()
    {
        return $this->hasMany(WorkflowApprover::class, 'workflow_stage_type_id');
    }

    /**
     * @return HasMany
     **/
    public function workflowStages()
    {
        return $this->hasMany(WorkflowStage::class, 'workflow_stage_type_id');
    }
}
