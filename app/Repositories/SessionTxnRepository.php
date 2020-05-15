<?php

namespace App\Repositories;

use App\Models\SessionTxn;
use App\Repositories\BaseRepository;

/**
 * Class SessionTxnRepository
 * @package App\Repositories
 * @version May 15, 2020, 9:02 am UTC
*/

class SessionTxnRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'txn_id',
        'orig_txn_no',
        'appended_txn_no',
        'txn_status',
        'comments'
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
        return SessionTxn::class;
    }
}
