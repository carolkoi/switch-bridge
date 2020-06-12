<?php

namespace App\Http\Controllers;

use App\DataTables\PendingTransactionsDataTable;
use App\DataTables\Scopes\TransactionDataTableScope;
use App\DataTables\SuccessTransactionsDataTable;
use App\Models\Partner;
use App\Models\Transactions;
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
//        $partners = Partner::pluck('partner_name', 'partner_name');
        $partners = Partner::get();
        $txnTypes = Transactions::pluck('req_field41', 'req_field41');
        return $pendingTransactionsDataTable->addScope(new TransactionDataTableScope())
            ->render('transactions.pending_index', ['partners' => $partners, 'txnTypes' => $txnTypes]);
    }
}
