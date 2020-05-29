<?php

namespace App\Http\Controllers;

use App\DataTables\FailedTransactionsDataTable;
use App\DataTables\Scopes\TransactionDataTableScope;
use App\Models\Partner;
use App\Repositories\TransactionsRepository;
use Illuminate\Http\Request;

class FailedTransactionsController extends Controller
{
    //
    /** @var  TransactionsRepository */
    private $transactionsRepository;

    public function __construct(TransactionsRepository $transactionsRepo)
    {
        $this->transactionsRepository = $transactionsRepo;
    }

    /**
     * Display a listing of the Transactions.
     *
     * @param FailedTransactionsController $failedTransactionsDataTable
     * @return Response
     */
    public function index(FailedTransactionsDataTable $failedTransactionsDataTable)
    {
        $partners = Partner::pluck('partner_name', 'partner_name');
        return $failedTransactionsDataTable->addScope(new TransactionDataTableScope())
            ->render('transactions.index', ['partners' => $partners]);
    }
}
