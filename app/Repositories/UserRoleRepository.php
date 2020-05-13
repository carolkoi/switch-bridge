<?php

namespace App\Repositories;

use App\Models\UserRole;
use Spatie\Permission\Models\Role;
use App\Repositories\BaseRepository;

/**
 * Class UserRoleRepository
 * @package App\Repositories
 * @version April 19, 2020, 6:55 pm UTC
*/

class UserRoleRepository extends BaseRepository
{
    /**
     * @var array
     */
    protected $fieldSearchable = [
        'name',
        'guard_name'
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
        return Role::class;
    }
}
