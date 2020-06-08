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
            $date1 =strtotime(date('Y-m-d H:i:s', strtotime('+3',strtotime($date[0]))))*1000;
            $date2 =strtotime(date('Y-m-d H:i:s', strtotime('+3',strtotime($date[1]))))*1000;
//            dd($date1, $date2 );
            return $query->whereBetween('date_time_modified', array($date1, $date2));
        }else
            return $query;
    }
}
