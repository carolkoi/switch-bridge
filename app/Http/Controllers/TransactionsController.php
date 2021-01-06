<?php

namespace App\Http\Controllers;

use App\DataTables\Scopes\TransactionDataTableScope;
use App\DataTables\TransactionsDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateTransactionsRequest;
use App\Http\Requests\UpdateTransactionsRequest;
use App\Models\ApiTransaction;
use App\Models\Partner;
use App\Models\SessionTxn;
use App\Models\Transactions;
use App\Repositories\SessionTxnRepository;
use App\Repositories\TransactionsRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Illuminate\Support\Facades\Log;
use Response;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
//use Yajra\DataTables\DataTables;
use DB;
use Yajra\Datatables\Facades\Datatables as AjaxDataTables;
use DataTables;


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
//    public function index(TransactionsDataTable $transactionsDataTable)
//    {
//
//        $partners = Partner::get();
//
////        dd($partners);
//        $txnTypes = Transactions::pluck('req_field41')->all();
////        Log::info(json_encode($txnTypes));
////        dd(collect($txnTypes));
//        //$transactions = Transactions::transactionsByCompany()->orderBy('date_time_added', 'desc')->paginate(30);
//        return $transactionsDataTable->addScope(new TransactionDataTableScope())
//            ->render('transactions.index', ['partners' => $partners, 'txnTypes' => array_unique($txnTypes)]);
//
//    }

    public function index(Request $request)
    {
        $partners = Partner::get();
        $txnTypes = Transactions::pluck('req_field41')->all();
        if ($request->ajax()) {
            $data = Transactions::select()->transactionsByCompany()->filterByInputString()->orderBy('iso_id', 'desc');
            return Datatables::of($data)
                ->addIndexColumn()
                ->editColumn('date_time_added', function ($transaction){
                   return date('Y-m-d H:i:s',strtotime('+3 hours',strtotime(date('Y-m-d H:i:s', ($transaction->date_time_added / 1000)))));
                })
                ->editColumn('paid_out_date', function ($transaction){
                  return  !empty($transaction->paid_out_date) ? date("Y-m-d H:i:s", strtotime($transaction->paid_out_date)+10800):null;
//                    date('Y-m-d H:i:s',strtotime('+3 hours',strtotime(date('Y-m-d H:i:s', ($transaction->date_time_added / 1000)))));
                })
                ->editColumn('req_field4', function ($transaction){
                    return intval($transaction->req_field4)/100;
                   })
                ->editColumn('req_field5', function ($transaction){
                    return  intval($transaction->req_field4)/100;
                })
                ->addColumn('action', function($transaction){
                    return $this->getActionColumn($transaction);
                })
                ->rawColumns(['action', 'res_field44'])
                ->setRowAttr([
                    'style' => function($query){
                        return $query->res_field48 == "FAILED" || $query->res_field48 == "UPLOAD-FAILED" ? 'color: #ff0000;' :
                            ( $query->res_field48 == "COMPLETED" ? 'color: #2E8B57;' : null);
                    }
                ])
                ->make(true);
        }

        return view('transactions.index', ['partners' => $partners, 'txnTypes' => array_unique($txnTypes)]);
    }

    protected function getActionColumn($data)
    {
        $showUrl = route('transactions.show', $data->iso_id);
        $editUrl = route('transactions.edit', $data->iso_id);
        if (Auth::check() && auth()->user()->can('Can Update Transaction')) {
            return "<a class='btn btn-primary btn-sm' data-value='$data->id' href='$showUrl'><i class='glyphicon glyphicon-eye-open'></i></a>
                        <a class='btn btn-default btn-sm' data-value='$data->id' href='$editUrl'><i class='glyphicon glyphicon-edit'></i></a>
 ";
        }
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
//        dd(strtotime(now())*1000, date('Y-m-d H:i', strtotime(now())), $transactions->date_time_modified, date('Y-m-d H:i', $transactions->date_time_modified/1000));

        $input = $request->all();
//        $datePaid = strtotime($request->input('paid_out_date'))*1000;


//        $hyphen = "-";
//        $plus = "+";
//        $appended = $transactions->res_field37 .= $hyphen .= substr(md5(microtime()),rand(0,26),1);

        if (empty($transactions)) {
            Flash::error('Transactions not found');

            return redirect(route('transactions.index'));
        }
        Transactions::where('iso_id', $iso_id)->update([
            'modified_by' => Auth::user()->id
            ]);
//        if ($transactions->res_field37 == $appended){
//            $appended = $transactions->res_field37 .= $plus .= substr(md5(microtime()),rand(0,26),1);
//        }
            $sessionTxn = SessionTxn::updateOrCreate([
                'txn_id' => $transactions->iso_id,
            ],
                [
                'txn_id' => $transactions->iso_id,
                'orig_txn_no' => $input['res_field37'],
//                'appended_txn_no' => $appended,
                'txn_status' => $input['res_field48'],
                'comments' => $input['res_field44'],
                'sync_message' => $request->has('sync_message') ? $input['sync_message'] : null,
            ]);

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
