<?php

namespace App\Repositories;

use App\Models\SurveyReports;
use App\Repositories\BaseRepository;

/**
 * Class SurveyReportsRepository
 * @package App\Repositories
 * @version November 6, 2019, 6:05 am UTC
*/

class SurveyReportsRepository extends BaseRepository
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
        return SurveyReports::class;
    }
}
