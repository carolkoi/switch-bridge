<?php

namespace WizPack\Workflow\Repositories\API;

use WizPack\Workflow\Models\Approvals;
use WizPack\Workflow\Repositories\BaseRepository;

/**
 * Class ApprovalsRepository
 * @package App\Repositories
 * @version December 1, 2019, 12:25 am UTC
*/

class ApprovalsRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
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
        return Approvals::class;
    }
}
