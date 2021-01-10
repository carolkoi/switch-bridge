<?php

namespace App\Http\Controllers;

use App\Models\Transactions;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Pagination\Paginator;

class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth');
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Contracts\Support\Renderable
     */
    public function index( Request $request)
    {
        $from = Carbon::now()->subDays(1)->format('Y-m-d');
        $now =  Carbon::now()->format('Y-m-d');
        $to = Carbon::now()->addDays(1)->format('Y-m-d');
        $date = array('start' => $from, 'today' => $now, 'end' => $to);

//        $today_transactions = Transactions::transactionsByCompany()->whereDate('created_at', Carbon::today())->get();
        $today_transactions = Transactions::transactionsByCompany()
            ->whereBetween('created_at', array($date['today'], $date['end']))->get();

        $yesterday_txns = Transactions::transactionsByCompany()
            ->whereBetween('created_at', array($date['start'], $date['today']))->get();


        $page = $request->has('page') ? $request->get('page') : 1;
        $limit = $request->has('limit') ? $request->get('limit') : 10;

        $take = 30;
        $skip = 0;
        $currentPage = $request->get('page', 1);
        $transactions = Transactions::transactionsByCompany()->take($take)
            ->skip($skip + (($currentPage - 1) * $take))
            ->orderBy('iso_id','desc')->get();
//        $transactions->paginate(2);
//        dd($transactions);

//        if (env('APP_ENV') == 'dev'){
//            $transactions->setPath('https://dev.slafrica.net:6810/');
//        }elseif (env('APP_ENV') == 'prod'){
//            $transactions->setPath('https://asgard.slafrica.net:9810/');
//        }

//        $transactions->setBaseUrl('custom/url');
        return view('home', ['transactions' => $transactions,
            'today_transactions' => $today_transactions, 'yesterday_txns' => $yesterday_txns ] );
    }


}
