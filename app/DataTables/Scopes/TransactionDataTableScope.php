<?php

namespace App\DataTables\Scopes;

use Yajra\DataTables\Contracts\DataTableScope;

class TransactionDataTableScope implements DataTableScope
{
    /**
     * Apply a query scope.
     *
     * @param \Illuminate\Database\Query\Builder|\Illuminate\Database\Eloquent\Builder $query
     * @return mixed
     */
    public function apply($query)
    {
        if (request()->has('from-to')) {
            $date = explode(" - ", request()->input('from-to', ""));
            $date1 = strtotime(trim($date[0])) * 1000;
            $date2 = strtotime(trim($date[1])) * 1000;
            return $query->whereBetween('date_time_added', array($date1, $date2));
            // return $query->where('id', 1);
        }else
            return $query->get();
    }
}
