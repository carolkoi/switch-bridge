<?php

namespace App\Repositories;

use App\Models\ApprovalWorkflow;
use App\Repositories\BaseRepository;

/**
 * Class ApprovalWorkflowRepository
 * @package App\Repositories
 * @version November 6, 2019, 2:00 pm UTC
*/

class ApprovalWorkflowRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        
    ];

    /**
     * Return searchable fields
     *
     * @return array
     */
    public function getFieldsSearchable()
    {
        return $this->fieldSearchable;
    }

    /**
     * Configure the Model
     **/
    public function model()
    {
        return ApprovalWorkflow::class;
    }
}
