<?php

namespace App\DataTables\Scopes;

use Carbon\Carbon;
use Yajra\DataTables\Contracts\DataTableScope;
use DateTime;

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

        $from = Carbon::now()->subDays(2)->format('Y-m-d');
        $to = Carbon::now()->format('Y-m-d');
        $day = array('start' => $from, 'end' => $to);

//        dd($day);

        if (request()->has('filter-partner') && request()->has('txn-type')
            && request()->has('report_time') && request()->has('from-to')){
            $partner = request()->input('filter-partner');
            $txnType = request()->input('txn-type');
            $reportTime = request()->input('report_time');
            $date = explode(" - ", request()->input('from-to', ""));
            $date1 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[0])))) * 1000;
            $date2 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[1])))) * 1000;
            if ($reportTime == 'trn_date'){
                return $query->where('req_field123', $partner)
                    ->where('req_field41', 'LIKE', "%$txnType%")->whereBetween('date_time_added', array($date1, $date2));
            }else
                return $query->where('req_field123', $partner)
                    ->where('req_field41', 'LIKE', "%$txnType%")
                    ->whereBetween('paid_out_date', array($date[0], $date[1]));

//
//                return $query->where('req_field123', $partner)
//                    ->where('req_field41', 'LIKE', "%$txnType%")->whereBetween('date_time_modified', array($date1, $date2));
        }
         if (request()->has('filter-partner') && request()->has('txn-type')) {
            $txnType = request()->input('txn-type');
            $partner = request()->input('filter-partner');
            return $query->where('req_field123', $partner)->where('req_field41', 'LIKE', "%$txnType%");
        }
         if (request()->has('filter-partner') && request()->has('report_time') && request()->has('from-to')) {
            $partner = request()->input('filter-partner');
             $reportTime = request()->input('report_time');

             $date = explode(" - ", request()->input('from-to', ""));
            $date1 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[0])))) * 1000;
            $date2 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[1])))) * 1000;
             if ($reportTime == 'trn_date'){
                 return $query->where('req_field123', $partner)->whereBetween('date_time_added', array($date1, $date2));
             }else
                 return $query->where('req_field123', $partner)->whereBetween('paid_out_date', array($date[0], $date[1]));
        }
        if (request()->has('txn-type') && request()->has('report_time') && request()->has('from-to')) {
            $txnType = request()->input('txn-type');
            $date = explode(" - ", request()->input('from-to', ""));
            $reportTime = request()->input('report_time');

            $date1 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[0])))) * 1000;
            $date2 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[1])))) * 1000;
            if ($reportTime == 'trn_date'){
                return $query->where('req_field41', 'LIKE', "%$txnType%")->whereBetween('date_time_added', array($date1, $date2));
            }else
                return $query->where('req_field41', 'LIKE', "%$txnType%")->whereBetween('paid_out_date', array($date[0], $date[1]));
        }
        if (request()->has('report_time') && request()->has('from-to')) {
            $reportTime = request()->input('report_time');

            $date = explode(" - ", request()->input('from-to', ""));
//            dd($date,  'yes', $reportTime);
            $date1 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[0])))) * 1000;
            $date2 = strtotime(date('Y-m-d H:i:s', strtotime('+3', strtotime($date[1])))) * 1000;
            if ($reportTime == 'trn_date'){
                return $query->whereBetween('date_time_added', array($date1, $date2));

            }else
//                return $query->whereBetween('date_time_modified', array($date1, $date2));
                return $query->whereBetween('paid_out_date', array($date[0], $date[1]));

        }

        if (request()->has('filter-partner')) {
//            dd('here');
            $txnType = request()->input('txn-type');
            $partner = request()->input('filter-partner');
            return $query->where('req_field123', $partner);
        }
        if (request()->has('txn-type')) {
            $txnType = request()->input('txn-type');
            return $query->where('req_field41', 'LIKE', "%$txnType%");
        }
            return $query->whereBetween('paid_out_date', array($day['start'], $day['end']));
//        return $query;
    }
}
