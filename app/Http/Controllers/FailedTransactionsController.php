<?php

namespace App\Http\Controllers;

use App\DataTables\FailedTransactionsDataTable;
use App\DataTables\Scopes\TransactionDataTableScope;
use App\Models\Partner;
use App\Models\Transactions;
use App\Repositories\TransactionsRepository;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use DataTables;

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
//    public function index(FailedTransactionsDataTable $failedTransactionsDataTable)
//    {
////        $partners = Partner::pluck('partner_name', 'partner_name');
//        $partners = Partner::get();
////        $txnTypes = Transactions::pluck('req_field41', 'req_field41');
//        $txnTypes = Transactions::pluck('req_field41')->all();
//        return $failedTransactionsDataTable->addScope(new TransactionDataTableScope())
//            ->render('transactions.failed_index', ['partners' => $partners, 'txnTypes' => array_unique($txnTypes)]);
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
            $data = Transactions::select()->transactionsByCompany()->orderBy('iso_id', 'desc')->where('res_field48', 'FAILED');
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
//
                ->rawColumns(['action', 'res_field44'])
                ->setRowAttr([
                    'style' => function($query){
                        return $query->res_field48 == "FAILED" || $query->res_field48 == "UPLOAD-FAILED" ? 'color: #ff0000;' :
                            ( $query->res_field48 == "COMPLETED" ? 'color: #2E8B57;' : null);
                    }
                ])
                ->make(true);
        }

        return view('transactions.failed_index', ['partners' => $all_partners, 'upesi_partners' => $upesi_partners, 'txnTypes' => array_unique($txnTypes)]);
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

}
