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
use Carbon\Carbon;
use Flash;
use App\Http\Controllers\AppBaseController;
use Illuminate\Support\Facades\Log;
use Response;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
//use Yajra\DataTables\DataTables;
use DB;
use WizPack\Workflow\Models\Approvals;
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
    public function iindex(TransactionsDataTable $transactionsDataTable)
    {

        $partners = Partner::get();

//        dd($partners);
        $txnTypes = Transactions::pluck('req_field41')->all();
//        Log::info(json_encode($txnTypes));
//        dd(collect($txnTypes));
        //$transactions = Transactions::transactionsByCompany()->orderBy('date_time_added', 'desc')->paginate(30);
        return $transactionsDataTable->addScope(new TransactionDataTableScope())
            ->render('transactions.index', ['partners' => $partners, 'txnTypes' => array_unique($txnTypes)]);

    }

    public function TableIndex(Request $request)
    {
        $from = Carbon::now()->subDays(60)->format('Y-m-d');
        $to = Carbon::now()->addDays(2)->format('Y-m-d');
        $date = array('start' => $from, 'end' => $to);
        $upesi_partners = Partner::WhereNotIn('partner_id', ['NGAO', 'CHIPPERCASH'])->get();
        $all_partners = Partner::get();
        $txnTypes = Transactions::pluck('req_field41')->all();
        $take = 30;
        $skip = 29;
        $currentPage = $request->get('page', 1);
        $transactions = Transactions::orderBy('iso_id','desc')->transactionsByCompany()
            ->filterByInputString()
            ->take($take)
            ->skip($skip + (($currentPage - 1) * $take))
            ->get();

        $transactions = Transactions::orderBy('iso_id', 'desc')->transactionsByCompany()
            ->search()->filterByInputString()->paginate(30);


        return view('transactions.index', ['transactions' =>$transactions, 'partners' => $all_partners,
            'upesi_partners' => $upesi_partners, 'txnTypes' => array_unique($txnTypes)]);

    }

    public function index(Request $request)
    {
        $upesi_partners = Partner::WhereNotIn('partner_id', ['NGAO', 'CHIPPERCASH'])->get();
        $all_partners = Partner::get();
        $txnTypes = Transactions::pluck('req_field41')->all();
        if ($request->ajax()) {
            $arrStart = explode("-", $request->get('from'));
            $arrEnd = explode("-", $request->get('to'));
            $start = Carbon::create($arrStart[0], $arrStart[1], $arrStart[2], 0, 0, 0);
            $end = Carbon::create($arrEnd[0], $arrEnd[1], $arrEnd[2], 23, 59, 59);
            $range = array('from' => $start, 'to' => $end);

            $data = Transactions::select(['iso_id', 'res_field48','date_time_added', 'date_time_modified',
                'req_field41', 'req_field34', 'sync_message', 'req_field37', 'req_field49', 'req_field4',
                'req_field50', 'req_field5', 'req_field105', 'req_field108','req_field102', 'res_field44',
                'req_field112', 'req_field123'])->transactionsByCompany()
                ->whereBetween('created_at', array($range['from'], $range['to']))->orderBy('iso_id', 'desc');
            return Datatables::of($data)
                ->addIndexColumn()
                ->editColumn('date_time_added', function ($transaction) {
                    return date('Y-m-d H:i:s', strtotime('+3 hours', strtotime(date('Y-m-d H:i:s', ($transaction->date_time_added / 1000)))));
                })
                ->editColumn('paid_out_date', function ($transaction) {
                    return !empty($transaction->paid_out_date) ? date("Y-m-d H:i:s", strtotime($transaction->paid_out_date) + 10800) : null;
//                    date('Y-m-d H:i:s',strtotime('+3 hours',strtotime(date('Y-m-d H:i:s', ($transaction->date_time_added / 1000)))));
                })
                ->editColumn('req_field4', function ($transaction) {
                    return intval($transaction->req_field4) / 100;
                })
                ->editColumn('req_field5', function ($transaction) {
                    return intval($transaction->req_field5) / 100;
                })
                ->editColumn('res_field48', 'transactions.datatables_status')
                ->addColumn('action', 'transactions.datatables_actions')
//                ->addColumn('action', function($transaction){
//                    return $this->getActionColumn($transaction);
//                })
                ->filter(function ($instance) use ($request) {

                    if ($request->has('req_field41')) {
//                        dd('hre');
                        $txnType = $request->get('req_field41');
//                        dd('here');
                        $instance->where('req_field41', 'LIKE', "%$txnType%");
                    }
                    if ($request->has('req_field123')) {
//                        dd('here');
                        $instance->where('req_field123', $request->get('req_field123'));
                    }

                    if ($request->has('from') && $request->has('to')){

                        $a = $request->get('from');
                        $b = $request->get('to');
//                        dd('here', $a, $b);
                        $range = array('from' => $a, 'to' => $b);
                        $instance->whereBetween('created_at', array($range['from'], $range['to']));

                    }

                    if (!empty($request->get('search'))) {
                        $instance->where(function ($w) use ($request) {
                            $search = $request->get('search');
                            $w->orWhere('req_field123', 'LIKE', "%$search%")
                                ->orWhere('req_field41', 'LIKE', "%$search%")
                                ->orWhere('sync_message', 'LIKE', "%$search%")
                                ->orWhere('req_field34', 'LIKE', "%$search%")
                                ->orWhere('req_field37', 'LIKE', "%$search%")
                                ->orWhere('req_field4', 'LIKE', "%$search%")
                                ->orWhere('req_field5', 'LIKE', "%$search%")
                                ->orWhere('req_field105', 'LIKE', "%$search%")
                                ->orWhere('req_field108', 'LIKE', "%$search%")
                                ->orWhere('req_field102', 'LIKE', "%$search%")
                                ->orWhere('res_field48', 'LIKE', "%$search%")
                                ->orWhere('paid_out_date', 'LIKE', "%$search%");
                        });
                    }
//
                })
                ->rawColumns(['action', 'res_field44', 'res_field48'])
                ->setRowAttr([
                    'style' => function ($query) {
                        return $query->res_field48 == "FAILED" || $query->res_field48 == "UPLOAD-FAILED" ? 'color: #ff0000;' :
                            ($query->res_field48 == "COMPLETED" ? 'color: #2E8B57;' : null);
                    }
                ])
                ->make(true);
        }

        return view('transactions.index', ['partners' => $all_partners,
            'upesi_partners' => $upesi_partners, 'txnTypes' => array_unique($txnTypes)]);
    }

    protected function vueIndex()
    {
        return view('transactions.vue_index');
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
     * @param int $iso_id
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
     * @param int $iso_id
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
        $approval = Approvals::updateOrCreate([
            'model_id' => $transactions->iso_id,
        ],
            [
                'user_id' => Auth::id(),
                'sent_by' => Auth::id(),
                'workflow_type' => 'transaction_approval',
                'collection_name' => 'transaction_approval',
                'model_id' => $transactions->iso_id,
                'model_type' => 'App\Models\Transactions',
                'awaiting_stage_id' => null,
                'company_id' => Auth::user()->company_id
            ]);

        //initiating the approval request
//        $approval = new Transactions();
//        $approval->addApproval($transactions);


        Flash::success('Approval Request to Update the Transaction sent successfully.');

        return redirect(route('transactions.index'));
    }

    /**
     * Remove the specified Transactions from storage.
     *
     * @param int $id
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

    public function search(Request $request)
    {
        if ($request->ajax()) {
//            dd('ajax');
            $output = "";
//            $search = $request->search;
            $search = $request->get('search');
            $partner = $request->get('partner');
//            dd($search);
            if(!empty($search)) {
                $transactions = Transactions::transactionsByCompany()->orderBy('iso_id', 'desc')
                    ->where('req_field123', 'LIKE', "%$search%")
                    ->orWhere('req_field41', 'LIKE', "%$search%")
                    ->orWhere('sync_message', 'LIKE', "%$search%")
                    ->orWhere('req_field34', 'LIKE', "%$search%")
                    ->orWhere('req_field37', 'LIKE', "%$search%")
                    ->orWhere('req_field4', 'LIKE', "%$search%")
                    ->orWhere('req_field5', 'LIKE', "%$search%")
                    ->orWhere('req_field105', 'LIKE', "%$search%")
                    ->orWhere('req_field108', 'LIKE', "%$search%")
                    ->orWhere('req_field102', 'LIKE', "%$search%")
                    ->orWhere('res_field48', 'LIKE', "%$search%")
                    ->orWhere('paid_out_date', 'LIKE', "%$search%")->get();
            }
            elseif (!empty($partner)){
//                dd('here');
                $transactions = Transactions::orderBy('iso_id', 'desc')->transactionsByCompany()
                    ->where('req_field123', 'LIKE', "%$partner%");
            }
            else
//                return redirect(route('transactions.index'));
                $transactions = Transactions::orderBy('iso_id', 'desc')->transactionsByCompany()->get();

            $total_transactions = $transactions->count();
            if($total_transactions > 0)
            {
                foreach($transactions as $transaction)
                {
//                    dd($transaction);
                    $output .= '<tr>'.
         '<td>'.$transaction->req_field123.'</td>'.
         '<td>'.(date('Y-m-d H:i:s',strtotime('+3 hours',strtotime(date('Y-m-d H:i:s', ($transaction->date_time_added / 1000)))))).'</td>'.
         '<td>'.(!empty($transaction->paid_out_date) ? date("Y-m-d H:i:s", strtotime($transaction->paid_out_date)+10800):null).'</td>'.
         '<td>'.$transaction->res_field48.'</td>'.
         '<td>'.$transaction->req_field41.'<td>'.
         '<td>'.$transaction->req_field34.'<td>'.
         '<td>'.($transaction->sync_message ? $transaction->sync_message : "N/A" ).'</td>'.
         '<td>'.$transaction->req_field37.'</td>'.
         '<td>'.$transaction->req_field49. " ".(intval($transaction->req_field4)/100).'</td>'.
         '<td>'.$transaction->req_field50.'</td>'.
         '<td>'. (intval($transaction->req_field5)/100).'<td>'.
         '<td>'.$transaction->req_field105.'</td>'.
         '<td>'.$transaction->req_field108.'</td>'.
         '<td>'.$transaction->req_field102.'</td>'.
         '<td>'.$transaction->res_field44.'</td>'.
         '<td>'. $transaction->req_field112.'<td>'.
                        '<td>'."action".'</td>'.

        '</tr>';
                }
            }
            else
            {
                $output = '
       <tr>
        <td align="center" colspan="5">No Data Found</td>
       </tr>
       ';
            }
            $data = array(
                'table_data'  => $output,
                'total_data'  => $total_transactions
            );
//            dd($data['table_data']);
//            dd($transactions);

//            echo json_encode($data);
            return response()->json($output);
//            return Response($transactions);
        }
    }
}
