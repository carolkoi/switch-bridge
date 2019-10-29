<?php

namespace App\Repositories;

use App\Models\Answer;
use App\Models\Question;
use App\Repositories\BaseRepository;

/**
 * Class AnswerRepository
 * @package App\Repositories
 * @version October 28, 2019, 6:39 pm UTC
 */
class AnswerRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'question_id',
        'choice'
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
        return Answer::class;
    }

    public function saveMultipleAnswers($id, $choice)
    {
        return Answer::create([
            'question_id' => $id,
            'choice' => $choice
        ]);

    }

    public function updateMultipleAnswers($choice, $id, $question_id)
    {
        return Answer::update([
            'question_id' => $id,
            'choice' => $choice
        ]);
    }
}
