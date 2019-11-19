<?php

namespace App\Repositories;

use App\Models\Response;
use App\Models\SentSurveys;
use App\Repositories\BaseRepository;

/**
 * Class SentSurveysRepository
 * @package App\Repositories
 * @version November 19, 2019, 9:10 am UTC
*/

class SentSurveysRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'token'
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
        return SentSurveys::class;
    }
    public function saveResponseUuid($template_id, $token)
    {
        return SentSurveys::create([
            'template_id' => $template_id,
            'token' => $token
        ]);

    }
}
