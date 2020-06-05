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
        if (request()->has('from-to') || request()->input('filter-partner')) {
            $partner = request()->input('filter-partner');
            $date = explode(" - ", request()->input('from-to', ""));
            $date1 =strtotime(date('Y-m-d H:i:s', strtotime($date[0])))*1000;
            $date2 =strtotime(date('Y-m-d H:i:s', strtotime($date[1])))*1000;

            return $query->whereBetween('date_time_added', array($date1, $date2))->where('req_field123', $partner);
        }else
            return $query;
    }
}
