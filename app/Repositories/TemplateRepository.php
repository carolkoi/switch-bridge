<?php

namespace App\Repositories;

use App\Models\Template;
use App\Repositories\BaseRepository;

/**
 * Class TemplateRepository
 * @package App\Repositories
 * @version October 28, 2019, 8:30 am UTC
*/

class TemplateRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'type',
        'name',
        'description',
        'status',
        'valid_from',
        'valid_until',
        'email_msg',
        'user.first_name',
        'user.last_name'
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
        return Template::class;
    }
}
