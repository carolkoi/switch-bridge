<?php

namespace App\Http\Controllers;

use App\DataTables\TransactionsDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateTransactionsRequest;
use App\Http\Requests\UpdateTransactionsRequest;
use App\Models\SessionTxn;
use App\Models\Transactions;
use App\Repositories\SessionTxnRepository;
use App\Repositories\TransactionsRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;
use Illuminate\Support\Facades\Auth;

class TransactionsController extends AppBaseController
{
    /** @var  TransactionsRepository */
    private $transactionsRepository;
    private $sessionTxnRepository;

    public function __construct(TransactionsRepository $transactionsRepo, SessionTxnRepository $sessionTxnRepo)
    {
        $this->transactionsRepository = $transactionsRepo;
        $this->sessionTxnRepository = $sessionTxnRepo;
    }

    /**
     * Display a listing of the Transactions.
     *
     * @param TransactionsDataTable $transactionsDataTable
     * @return Response
     */
    public function index(TransactionsDataTable $transactionsDataTable)
    {
        return $transactionsDataTable->render('transactions.index');
    }

    /**
     * Show the form for creating a new Transactions.
     *
     * @return Response
     */
    public function create()
    {
        return view('transactions.create');
    }

    /**
     * Store a newly created Transactions in storage.
     *
     * @param CreateTransactionsRequest $request
     *
     * @return Response
     */
    public function store(CreateTransactionsRequest $request)
    {
        $input = $request->all();

        $transactions = $this->transactionsRepository->create($input);

        Flash::success('Transactions saved successfully.');

        return redirect(route('transactions.index'));
    }

    /**
     * Display the specified Transactions.
     *
     * @param  int $iso_id
     *
     * @return Response
     */
    public function show($iso_id)
    {
//        dd($iso_id);
        $transactions = Transactions::where('iso_id', $iso_id)->first();
//        dd($transactions);

        if (empty($transactions)) {
            Flash::error('Transactions not found');

            return redirect(route('transactions.index'));
        }

        return view('transactions.show')->with('transactions', $transactions);
    }

    /**
     * Show the form for editing the specified Transactions.
     *
     * @param  int $iso_id
     *
     * @return Response
     */
    public function edit($iso_id)
    {
        $transactions = Transactions::where('iso_id', $iso_id)->first();
        $txnExist = SessionTxn::where('txn_id', $iso_id)->exists();
//        if ($txnExist){
//            dd($txnExist);
//
//        }else
//            dd('tehre');

        if (empty($transactions)) {
            Flash::error('Transactions not found');

            return redirect(route('transactions.index'));
        }

        return view('transactions.edit')->with(['transactions' => $transactions, 'txnExist' => $txnExist]);
    }

    /**
     * Update the specified Transactions in storage.
     *
     * @param $iso_id
     * @param UpdateTransactionsRequest $request
     *
     * @return Response
     */
    public function update($iso_id, UpdateTransactionsRequest $request)
    {
        $transactions = Transactions::where('iso_id', $iso_id)->first();
        $input = $request->all();
        $hyphen = "-";
        $appended = $transactions->res_field37 .= $hyphen .= substr(md5(microtime()),rand(0,26),1);
//        dd($input, $appended);

        if (empty($transactions)) {
            Flash::error('Transactions not found');

            return redirect(route('transactions.index'));
        }
        Transactions::where('iso_id', $iso_id)->update(['modified_by' => Auth::user()->id]);
//        if ($request->get('res_field48') == "AML-APPROVED" || $request->get('res_field48') == "COMPLETED" || $request->get('res_field48') == "FAILED"){
            $sessionTxn = $this->sessionTxnRepository->create([
                'txn_id' => $transactions->iso_id,
                'orig_txn_no' => $input['res_field37'],
                'appended_txn_no' => $appended,
                'txn_status' => $input['res_field48'],
                'comments' => $input['res_field44'],
                'sync_message' => $request->has('sync_message') ? $input['sync_message'] : null,
            ]);
//        }

        //initiating the approval request
        $approval = new Transactions();
        $approval->addApproval($transactions);

        Flash::success('Approval Request to Update the Transaction sent successfully.');

        return redirect(route('transactions.index'));
    }

    /**
     * Remove the specified Transactions from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($iso_id)
    {
        $transactions = Transactions::where('iso_id', $iso_id)->first();

        if (empty($transactions)) {
            Flash::error('Transactions not found');

            return redirect(route('transactions.index'));
        }

        Transactions::where('iso_id', $iso_id)->delete();

        Flash::success('Transactions deleted successfully.');

        return redirect(route('transactions.index'));
    }

    public function getTransactionStatus($status)
    {
        // Fetch transaction status
        $txn_status = array(
            'AML-APPROVED' => 'AML-APPROVED',
            'FAILED' => 'FAILED',
            'INIT-FAILED' => 'INIT-FAILED',
            'AML-FAILED' => 'AML-FAILED',
            'COMPLETED' => 'COMPLETED',
            'UPLOADED ' => 'UPLOADED ',
            'UPLOAD-FAILED' => 'UPLOAD FAILED',
        );
        $txn_status_aml_failed = array(
            'AML-APPROVED' => 'AML-APPROVED',
            'FAILED' => 'FAILED',
//            'INIT-FAILED' => 'INIT-FAILED',
//            'AML-FAILED' => 'AML-FAILED',
//            'COMPLETED' => 'COMPLETED',
//            'UPLOADED ' => 'UPLOADED ',
//            'UPLOAD-FAILED' => 'UPLOAD FAILED',
        );


//        $transactionStatus = Transactions::where('res_field48', $status)->get()->pluck('res_field48', 'res_field48');
        return response()->json(['data' => $txn_status, 'aml_failed_data' => $txn_status_aml_failed]);
    }
}
