<?php

namespace WizPack\Workflow\Repositories;

use Prettus\Repository\Eloquent\BaseRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use  WizPack\Workflow\Models\WorkflowStep;

/**
 * Class WorkflowStepRepositoryEloquent.
 *
 * @package namespace App\Repositories\Workflow;
 */
class WorkflowStepRepository extends BaseRepository
{
    /**
     * Specify Model class name
     *
     * @return string
     */
    public function model()
    {
        return WorkflowStep::class;
    }

    

    /**
     * Boot up the repository, pushing criteria
     */
    public function boot()
    {
        $this->pushCriteria(app(RequestCriteria::class));
    }
    
}
