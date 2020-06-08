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
        if (request()->has('filter-partner')){
            $partner = request()->input('filter-partner');
            return $query->where('req_field123', $partner);
        }elseif (request()->has('txn-type')){
            $txnType = request()->input('txn-type');
            return $query->where('req_field41', $txnType);
        }elseif (request()->has('from-to')) {
            $date = explode(" - ", request()->input('from-to', ""));
//            dd(date('Y-m-d H:i:s', strtotime($date[0])));
            $time = time();
            $date = strtotime('+3 hours', $time);
//            dd(date('d-m-y H:i', $time), date('d-m-y H:i', $date));
//            dd(time(), date('d-m-y H:i', time()), strtotime(now()), date('d-m-y H:i', strtotime(now())));

            $date1 = strtotime($date[0]);
            $date2 = strtotime($date[1]);
//            dd(date('d-m-y H:i:s', $date1), date('d-m-y H:i:s', $date2));
            $start = strtotime('+3 hours', $date1);
            $end = strtotime('+3 hours', $date2);
//            dd(date('d-m-y H:i', $date1), date('d-m-y H:i', $start), date('d-m-y H:i', $date2),  date('d-m-y H:i', $end));
            return $query->whereBetween('date_time_modified', array($start, $end));
        }else
            return $query;
    }
}
