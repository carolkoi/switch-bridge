<?php

namespace App\Http\Controllers;

use App\Models\Transactions;
use Illuminate\Http\Request;

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
    $all_transactions = Transactions::all();
        $transactions = Transactions::orderBy('date_time_added', 'desc')->paginate(80);
        return view('home', ['transactions' => $transactions, 'all_transactions' => $all_transactions] );
    }
}
