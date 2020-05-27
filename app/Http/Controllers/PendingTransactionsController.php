<?php

namespace App\Http\Controllers;

use App\DataTables\PendingTransactionsDataTable;
use App\DataTables\Scopes\TransactionDataTableScope;
use App\DataTables\SuccessTransactionsDataTable;
use Illuminate\Http\Request;

class PendingTransactionsController extends Controller
{
    //
    /**
     * Display a listing of the Transactions.
     *
     * @param PendingTransactionsDataTable $pendingTransactionsDataTable
     * @return Response
     */
    public function index(PendingTransactionsDataTable $pendingTransactionsDataTable)
    {
        return $pendingTransactionsDataTable->addScope(new TransactionDataTableScope())->render('transactions.pending_index');
    }
}
