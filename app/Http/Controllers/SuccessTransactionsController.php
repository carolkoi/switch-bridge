<?php

namespace App\Http\Controllers;

use App\DataTables\Scopes\TransactionDataTableScope;
use App\DataTables\SuccessTransactionsDataTable;
use App\Http\Requests\CreateTransactionsRequest;
use App\Http\Requests\UpdateTransactionsRequest;
use App\Models\Partner;
use App\Models\Transactions;
use App\Repositories\TransactionsRepository;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use DataTables;

class SuccessTransactionsController extends AppBaseController
{
    /** @var  TransactionsRepository */
    private $transactionsRepository;

    public function __construct(TransactionsRepository $transactionsRepo)
    {
        $this->transactionsRepository = $transactionsRepo;
    }

    /**
     * Display a listing of the Transactions.
     *
     * @param SuccessTransactionsDataTable $successTransactionsDataTable
     * @return Response
     */
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

            $take = 30;
            $skip = 0;
            $currentPage = $request->get('page', 1);
//            $transactions = Transactions::select('iso_id', 'res_field48','date_time_added','paid_out_date', 'date_time_modified',
//                'req_field41', 'req_field34', 'sync_message', 'req_field37', 'req_field49', 'req_field4',
//                'req_field50', 'req_field5', 'req_field105', 'req_field108','req_field102', 'res_field44',
//                'req_field112', 'req_field123', 'req_field124')->transactionsByCompany()->take($take)
//                ->skip($skip + (($currentPage - 1) * $take))
//                ->orderBy('iso_id','desc')->get();

            $data = Transactions::select('iso_id', 'res_field48','date_time_added','paid_out_date', 'date_time_modified',
                'req_field41', 'req_field34', 'sync_message', 'req_field37', 'req_field49', 'req_field4',
                'req_field50', 'req_field5', 'req_field105', 'req_field108','req_field102', 'res_field44',
                'req_field112', 'req_field123', 'req_field124')->transactionsByCompany()
                ->whereBetween('created_at', array($range['from'], $range['to']))->take($take)
                ->skip($skip + (($currentPage - 1) * $take))->orderBy('iso_id', 'desc')->where('res_field48', 'COMPLETED');
//            dd($data)->count();
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
//
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

        return view('transactions.success_index', ['partners' => $all_partners,
            'upesi_partners' => $upesi_partners, 'txnTypes' => array_unique($txnTypes)]);
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

        if (empty($transactions)) {
            Flash::error('Transactions not found');

            return redirect(route('transactions.index'));
        }

        return view('transactions.edit')->with('transactions', $transactions);
    }

    /**
     * Update the specified Transactions in storage.
     *
     * @param  int              $id
     * @param UpdateTransactionsRequest $request
     *
     * @return Response
     */
    public function update($iso_id, UpdateTransactionsRequest $request)
    {
        $transactions = Transactions::where('iso_id', $iso_id)->first();

        if (empty($transactions)) {
            Flash::error('Transactions not found');

            return redirect(route('transactions.index'));
        }

        $transactions = $this->transactionsRepository->update($request->all(), $iso_id);

        Flash::success('Transactions updated successfully.');

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
        $transactions = $this->transactionsRepository->find($iso_id);

        if (empty($transactions)) {
            Flash::error('Transactions not found');

            return redirect(route('transactions.index'));
        }

        $this->transactionsRepository->delete($iso_id);

        Flash::success('Transactions deleted successfully.');

        return redirect(route('transactions.index'));
    }
}
