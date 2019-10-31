<?php

namespace App\Repositories;

use App\Models\Survey;
use App\Repositories\BaseRepository;

/**
 * Class SurveyRepository
 * @package App\Repositories
 * @version October 31, 2019, 6:27 am UTC
*/

class SurveyRepository extends BaseRepository
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
        return Survey::class;
    }
}
