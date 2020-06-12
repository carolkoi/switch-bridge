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
        if (request()->has('filter-partner') && request()->has('txn-type') && request()->has('from-to')){
//            dd('yes');
            $partner = request()->input('filter-partner');
            $txnType = request()->input('txn-type');
            $date = explode(" - ", request()->input('from-to', ""));
            $date1 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[0])))) * 1000;
            $date2 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[1])))) * 1000;
            return $query->where('req_field123', $partner)
                ->where('req_field41', 'LIKE', "%$txnType%")
                ->whereBetween('date_time_modified', array($date1, $date2));
        }
         if (request()->has('filter-partner') && request()->has('txn-type')) {
            $txnType = request()->input('txn-type');
            $partner = request()->input('filter-partner');
            return $query->where('req_field123', $partner)->where('req_field41', 'LIKE', "%$txnType%");
        }
         if (request()->has('filter-partner') && request()->has('from-to')) {
            $partner = request()->input('filter-partner');
            $date = explode(" - ", request()->input('from-to', ""));
            $date1 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[0])))) * 1000;
            $date2 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[1])))) * 1000;
            return $query->where('req_field123', $partner)->whereBetween('date_time_modified', array($date1, $date2));
        }
        if (request()->has('txn-type') && request()->has('from-to')) {
//            dd('yes');
            $txnType = request()->input('txn-type');
            $date = explode(" - ", request()->input('from-to', ""));
            $date1 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[0])))) * 1000;
            $date2 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[1])))) * 1000;
            return $query->where('req_field41', 'LIKE', "%$txnType%")->whereBetween('date_time_modified', array($date1, $date2));
        }
        if (request()->has('filter-partner')) {
//            $txnType = request()->input('txn-type');
            $partner = request()->input('filter-partner');
            return $query->where('req_field123', $partner);
        }
        if (request()->has('txn-type')) {
            $txnType = request()->input('txn-type');
            return $query->where('req_field41', 'LIKE', "%$txnType%");
        }
        if (request()->has('from-to')) {
            $date = explode(" - ", request()->input('from-to', ""));
            $date1 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[0])))) * 1000;
            $date2 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[1])))) * 1000;
            return $query->whereBetween('date_time_modified', array($date1, $date2));
        }
            return $query;
    }
}
