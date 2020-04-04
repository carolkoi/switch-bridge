<?php

namespace App\Http\Controllers;

use App\DataTables\TransactionsDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateTransactionsRequest;
use App\Http\Requests\UpdateTransactionsRequest;
use App\Models\Transactions;
use App\Repositories\TransactionsRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class TransactionsController extends AppBaseController
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

        $transactions = Transactions::where('iso_id', $iso_id)->update($request->except(['_method', '_token']));
//        dd($transactions);

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
        $transactions = Transactions::where('iso_id', $iso_id)->first();

        if (empty($transactions)) {
            Flash::error('Transactions not found');

            return redirect(route('transactions.index'));
        }

        Transactions::where('iso_id', $iso_id)->delete();

        Flash::success('Transactions deleted successfully.');

        return redirect(route('transactions.index'));
    }
}
