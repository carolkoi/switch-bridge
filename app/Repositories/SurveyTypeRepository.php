<?php

namespace App\Repositories;

use App\Models\SurveyType;
use App\Repositories\BaseRepository;

/**
 * Class SurveyTypeRepository
 * @package App\Repositories
 * @version November 18, 2019, 7:38 am UTC
*/

class SurveyTypeRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'type'
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
        return SurveyType::class;
    }
}
