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
    public function index()
    {
        $all_transactions = Transactions::transactionsByCompany()->get();
        $no_of_trns = Transactions::transactionsByCompany()->get()->count();

        $today_transactions = Transactions::whereDate('created_at', Carbon::today())->get();
        $yesterday = date("Y-m-d m:h:s", strtotime( '-1 days' ) );
        $yesterday_txns = Transactions::whereDate('created_at', $yesterday )->get();

        $transactions = Transactions::transactionsByCompany()->orderBy('date_time_added', 'desc')->paginate(30);
        if (env('APP_ENV') == 'dev'){
            $transactions->setPath('https://dev.slafrica.net:6810/');
        }elseif (env('APP_ENV') == 'prod'){
            $transactions->setPath('https://asgard.slafrica.net:9810/');
        }

//        $transactions->setBaseUrl('custom/url');
        return view('home', ['transactions' => $transactions, 'all_transactions' => $all_transactions,
            'today_transactions' => $today_transactions, 'yesterday_txns' => $yesterday_txns,
            'txn_no' => $no_of_trns] );
    }
}
