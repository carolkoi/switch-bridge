<?php

namespace App\Repositories;

use App\Models\ResponseReports;
use App\Repositories\BaseRepository;

/**
 * Class ResponseReportsRepository
 * @package App\Repositories
 * @version November 6, 2019, 6:08 am UTC
*/

class ResponseReportsRepository extends BaseRepository
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
        return ResponseReports::class;
    }
}
