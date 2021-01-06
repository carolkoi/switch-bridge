<?php

namespace App\Http\Controllers;

use App\DataTables\Scopes\TransactionDataTableScope;
use App\DataTables\SuccessTransactionsDataTable;
use App\Http\Requests\CreateTransactionsRequest;
use App\Http\Requests\UpdateTransactionsRequest;
use App\Models\Partner;
use App\Models\Transactions;
use App\Repositories\TransactionsRepository;
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
//    public function index(SuccessTransactionsDataTable $successTransactionsDataTable)
//    {
////        $partners = Partner::pluck('partner_name', 'partner_name');
//        $partners = Partner::get();
////        $txnTypes = Transactions::pluck('req_field41', 'req_field41');
//        $txnTypes = Transactions::pluck('req_field41')->all();
//        return $successTransactionsDataTable->addScope(new TransactionDataTableScope())
//            ->render('transactions.success_index', ['partners' => $partners, 'txnTypes' => array_unique($txnTypes)]);
//    }
    public function index(Request $request)
    {
        $upesi_partners = Partner::WhereNotIn('partner_id', ['NGAO', 'CHIPPERCASH'])->get();
        $all_partners = Partner::get();
        $txnTypes = Transactions::pluck('req_field41')->all();
        if ($request->ajax()) {
//            if ($request->has('partner')) {
//
//                $data = Transactions::select()->transactionsByCompany()->where('req_field123', $request->get('partner'));
//            }elseif ($request->has('type')){
//                $txnType = $request->input('type');
//                $data = Transactions::select()->transactionsByCompany() ->where('req_field41', 'LIKE', "%$txnType%");
//            }elseif ($request->has('partner') && $request->has('type')){
//                $partner =$request->input('partner');
//                $txnType = $request->input('type');
//                $data = Transactions::select()->transactionsByCompany()->where('req_field123', $partner)
//                    ->where('req_field41', 'LIKE', "%$txnType%");
//            }
            $data = Transactions::select()->where('res_field48', 'COMPLETED')->transactionsByCompany()->filterByInputString()->orderBy('iso_id', 'desc');
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
                    return  intval($transaction->req_field5)/100;
                })
                ->editColumn('res_field48', 'transactions.datatables_status')
                ->addColumn('action', 'transactions.datatables_actions')
//                ->addColumn('action', function($transaction){
//                    return $this->getActionColumn($transaction);
//                })
                ->rawColumns(['action', 'res_field44','res_field48'])
                ->rawColumns(['action', 'res_field44'])
                ->setRowAttr([
                    'style' => function($query){
                        return $query->res_field48 == "FAILED" || $query->res_field48 == "UPLOAD-FAILED" ? 'color: #ff0000;' :
                            ( $query->res_field48 == "COMPLETED" ? 'color: #2E8B57;' : null);
                    }
                ])
                ->make(true);
        }

        return view('transactions.success_index', ['partners' => $all_partners, 'upesi_partners' => $upesi_partners, 'txnTypes' => array_unique($txnTypes)]);
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
