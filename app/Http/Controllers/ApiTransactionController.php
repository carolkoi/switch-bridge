<?php

namespace App\Http\Controllers;

use App\DataTables\ApiTransactionDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateApiTransactionRequest;
use App\Http\Requests\UpdateApiTransactionRequest;
use App\Repositories\ApiTransactionRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class ApiTransactionController extends AppBaseController
{
    /** @var  ApiTransactionRepository */
    private $apiTransactionRepository;

    public function __construct(ApiTransactionRepository $apiTransactionRepo)
    {
        $this->apiTransactionRepository = $apiTransactionRepo;
    }

    /**
     * Display a listing of the ApiTransaction.
     *
     * @param ApiTransactionDataTable $apiTransactionDataTable
     * @return Response
     */
    public function index(ApiTransactionDataTable $apiTransactionDataTable)
    {
        return $apiTransactionDataTable->render('api_transactions.index');
    }

    /**
     * Show the form for creating a new ApiTransaction.
     *
     * @return Response
     */
    public function create()
    {
        return view('api_transactions.create');
    }

    /**
     * Store a newly created ApiTransaction in storage.
     *
     * @param CreateApiTransactionRequest $request
     *
     * @return Response
     */
    public function store(CreateApiTransactionRequest $request)
    {
        $input = $request->all();

        $apiTransaction = $this->apiTransactionRepository->create($input);

        Flash::success('Api Transaction saved successfully.');

        return redirect(route('apiTransactions.index'));
    }

    /**
     * Display the specified ApiTransaction.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $apiTransaction = $this->apiTransactionRepository->find($id);

        if (empty($apiTransaction)) {
            Flash::error('Api Transaction not found');

            return redirect(route('apiTransactions.index'));
        }

        return view('api_transactions.show')->with('apiTransaction', $apiTransaction);
    }

    /**
     * Show the form for editing the specified ApiTransaction.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $apiTransaction = $this->apiTransactionRepository->find($id);

        if (empty($apiTransaction)) {
            Flash::error('Api Transaction not found');

            return redirect(route('apiTransactions.index'));
        }

        return view('api_transactions.edit')->with('apiTransaction', $apiTransaction);
    }

    /**
     * Update the specified ApiTransaction in storage.
     *
     * @param  int              $id
     * @param UpdateApiTransactionRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateApiTransactionRequest $request)
    {
        $apiTransaction = $this->apiTransactionRepository->find($id);

        if (empty($apiTransaction)) {
            Flash::error('Api Transaction not found');

            return redirect(route('apiTransactions.index'));
        }

        $apiTransaction = $this->apiTransactionRepository->update($request->all(), $id);

        Flash::success('Api Transaction updated successfully.');

        return redirect(route('apiTransactions.index'));
    }

    /**
     * Remove the specified ApiTransaction from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $apiTransaction = $this->apiTransactionRepository->find($id);

        if (empty($apiTransaction)) {
            Flash::error('Api Transaction not found');

            return redirect(route('apiTransactions.index'));
        }

        $this->apiTransactionRepository->delete($id);

        Flash::success('Api Transaction deleted successfully.');

        return redirect(route('apiTransactions.index'));
    }
}
