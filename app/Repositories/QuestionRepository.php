<?php

namespace App\Repositories;

use App\Models\Question;
use App\Repositories\BaseRepository;

/**
 * Class QuestionRepository
 * @package App\Repositories
 * @version October 28, 2019, 1:32 pm UTC
*/

class QuestionRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'template_id',
        'question',
        'type',
        'answer_id',
        'status',
        'description'
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
        return Question::class;
    }
}
