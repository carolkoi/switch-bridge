<?php

namespace App\Http\Controllers;

use App\DataTables\FloatBalanceDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateFloatBalanceRequest;
use App\Http\Requests\UpdateFloatBalanceRequest;
use App\Models\FloatBalance;
use App\Models\Partner;
use App\Repositories\FloatBalanceRepository;
use App\Http\Controllers\AppBaseController;
use Flash;
use Illuminate\Contracts\View\Factory;
use Illuminate\Http\RedirectResponse;
use Illuminate\Routing\Redirector;
use Illuminate\View\View;
use Response;


class FloatBalanceController extends AppBaseController
{
    /** @var  FloatBalanceRepository */
    private $floatBalanceRepository;

    public function __construct(FloatBalanceRepository $floatBalanceRepo)
    {
        $this->floatBalanceRepository = $floatBalanceRepo;
    }

    /**
     * Display a listing of the FloatBalance.
     *
     * @param FloatBalanceDataTable $floatBalanceDataTable
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function index(FloatBalanceDataTable $floatBalanceDataTable)
    {
        return $floatBalanceDataTable->render('float_balances.index');
    }

    /**
     * Show the form for creating a new FloatBalance.
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function create()
    {
        $partners = Partner::all();
//        dd($partners);
        return view('float_balances.create', ['partners' => $partners]);
    }

    public function home()
    {
        $partners = Partner::all();
//        dd($partners);
        return view('float_balances.home_float', ['partners' => $partners]);
    }

    /**
     * Store a newly created FloatBalance in storage.
     *
     * @param CreateFloatBalanceRequest $request
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function store(CreateFloatBalanceRequest $request)
    {
        $input = $request->all();
//        dd($input);

        $amount= FloatBalance::sum('amount');
        $prev_running_balance = FloatBalance::orderBy('floattransactionid', 'desc')->first();

            $input['runningbal'] = $prev_running_balance->runningbal;


        $floatBalance = $this->floatBalanceRepository->create($input);


        //initiating the approval request
        $approval = new FloatBalance();
        $approval->addApproval($floatBalance);

        Flash::success('Float Balance saved successfully.');

        return redirect(route('floatBalances.index'));
    }

    /**
     * Display the specified FloatBalance.
     *
     * @param  int $id
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function show($id)
    {
        $floatBalance = $this->floatBalanceRepository->find($id);

        if (empty($floatBalance)) {
            Flash::error('Float Balance not found');

            return redirect(route('floatBalances.index'));
        }

        return view('float_balances.show')->with('floatBalance', $floatBalance);
    }

    /**
     * Show the form for editing the specified FloatBalance.
     *
     * @param  int $id
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function edit($id)
    {
        $floatBalance = $this->floatBalanceRepository->find($id);

        if (empty($floatBalance)) {
            Flash::error('Float Balance not found');

            return redirect(route('floatBalances.index'));
        }

        return view('float_balances.edit')->with('floatBalance', $floatBalance);
    }

    /**
     * Update the specified FloatBalance in storage.
     *
     * @param  int              $id
     * @param UpdateFloatBalanceRequest $request
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function update($id, UpdateFloatBalanceRequest $request)
    {
        $floatBalance = $this->floatBalanceRepository->find($id);

        if (empty($floatBalance)) {
            Flash::error('Float Balance not found');

            return redirect(route('floatBalances.index'));
        }

        $prev_running_balance = FloatBalance::orderBy('floattransactionid', 'desc')->first();

        $input['runningbal'] = $prev_running_balance->runningbal;

        $floatBalance = $this->floatBalanceRepository->update($request->all(), $id);

        //initiating the approval request
        $approval = new FloatBalance();
        $approval->addApproval($floatBalance);

        Flash::success('Float Balance updated successfully.');

        return redirect(route('floatBalances.index'));
    }

    /**
     * Remove the specified FloatBalance from storage.
     *
     * @param  int $id
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function destroy($id)
    {
        $floatBalance = $this->floatBalanceRepository->find($id);

        if (empty($floatBalance)) {
            Flash::error('Float Balance not found');

            return redirect(route('floatBalances.index'));
        }

        $this->floatBalanceRepository->delete($id);

        Flash::success('Float Balance deleted successfully.');

        return redirect(route('floatBalances.index'));
    }
}
