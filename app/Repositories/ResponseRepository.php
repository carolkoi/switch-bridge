<?php

namespace App\Repositories;

use App\Models\Response;
use App\Repositories\BaseRepository;

/**
 * Class ResponseRepository
 * @package App\Repositories
 * @version October 31, 2019, 8:29 am UTC
*/

class ResponseRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'user_id',
        'client_id',
        'template_id',
        'question_id',
        'answer_type',
        'answer'
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
        return Response::class;
    }

    public function saveSurveyResponses($user_id, $survey_id, $question_id, $answer_type, $answer){

        return $this->create([
            'user_id' => NULL,
            'survey_id' => $map[1],
            'question_id' => $map[2],
            'answer_type' => $map[3],
            'answer' => is_array($dt)? json_encode($dt):(is_int($dt) ? strval($dt) : $dt),
        ]);
    }

}
