<?php

namespace App\DataTables\Scopes;

use Yajra\DataTables\Contracts\DataTableScope;

class CustMessageScope implements DataTableScope
{
    protected $phone_number;

    public function __construct($phone_no)
    {
        $this->phone_number = $phone_no;
    }
    /**
     * Apply a query scope.
     *
     * @param \Illuminate\Database\Query\Builder|\Illuminate\Database\Eloquent\Builder $query
     * @return mixed
     */
    public function apply($query)
    {
         return $query->where('mobilenumber', $this->phone_number);
    }
}
