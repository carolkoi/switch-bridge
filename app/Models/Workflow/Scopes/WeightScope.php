<?php

namespace App\Models\Workflow\Scopes;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Scope;

class WeightScope implements Scope
{
    protected $table;

    public function __construct($table)
    {
        $this->table = $table;
    }

    /**
     * Apply the scope to a given Eloquent query builder.
     *
     * @param Builder $builder
     * @param Model $model
     * @return void
     */
    public function apply(Builder $builder, Model $model)
    {
        $builder->orderBy($this->table.'.weight');
    }
}