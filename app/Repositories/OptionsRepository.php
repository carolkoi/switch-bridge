<?php

namespace App\Repositories;

use App\Models\Options;
use App\Repositories\BaseRepository;

/**
 * Class OptionsRepository
 * @package App\Repositories
 * @version November 6, 2019, 1:59 pm UTC
*/

class OptionsRepository extends BaseRepository
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
        return Options::class;
    }
}
