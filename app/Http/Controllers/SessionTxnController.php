<?php

namespace App\Http\Controllers;

use App\DataTables\SessionTxnDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateSessionTxnRequest;
use App\Http\Requests\UpdateSessionTxnRequest;
use App\Repositories\SessionTxnRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class SessionTxnController extends AppBaseController
{
    /** @var  SessionTxnRepository */
    private $sessionTxnRepository;

    public function __construct(SessionTxnRepository $sessionTxnRepo)
    {
        $this->sessionTxnRepository = $sessionTxnRepo;
    }

    /**
     * Display a listing of the SessionTxn.
     *
     * @param SessionTxnDataTable $sessionTxnDataTable
     * @return Response
     */
    public function index(SessionTxnDataTable $sessionTxnDataTable)
    {
        return $sessionTxnDataTable->render('session_txns.index');
    }

    /**
     * Show the form for creating a new SessionTxn.
     *
     * @return Response
     */
    public function create()
    {
        return view('session_txns.create');
    }

    /**
     * Store a newly created SessionTxn in storage.
     *
     * @param CreateSessionTxnRequest $request
     *
     * @return Response
     */
    public function store(CreateSessionTxnRequest $request)
    {
        $input = $request->all();

        $sessionTxn = $this->sessionTxnRepository->create($input);

        Flash::success('Session Txn saved successfully.');

        return redirect(route('sessionTxns.index'));
    }

    /**
     * Display the specified SessionTxn.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $sessionTxn = $this->sessionTxnRepository->find($id);

        if (empty($sessionTxn)) {
            Flash::error('Session Txn not found');

            return redirect(route('sessionTxns.index'));
        }

        return view('session_txns.show')->with('sessionTxn', $sessionTxn);
    }

    /**
     * Show the form for editing the specified SessionTxn.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $sessionTxn = $this->sessionTxnRepository->find($id);

        if (empty($sessionTxn)) {
            Flash::error('Session Txn not found');

            return redirect(route('sessionTxns.index'));
        }

        return view('session_txns.edit')->with('sessionTxn', $sessionTxn);
    }

    /**
     * Update the specified SessionTxn in storage.
     *
     * @param  int              $id
     * @param UpdateSessionTxnRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateSessionTxnRequest $request)
    {
        $sessionTxn = $this->sessionTxnRepository->find($id);

        if (empty($sessionTxn)) {
            Flash::error('Session Txn not found');

            return redirect(route('sessionTxns.index'));
        }

        $sessionTxn = $this->sessionTxnRepository->update($request->all(), $id);

        Flash::success('Session Txn updated successfully.');

        return redirect(route('sessionTxns.index'));
    }

    /**
     * Remove the specified SessionTxn from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $sessionTxn = $this->sessionTxnRepository->find($id);

        if (empty($sessionTxn)) {
            Flash::error('Session Txn not found');

            return redirect(route('sessionTxns.index'));
        }

        $this->sessionTxnRepository->delete($id);

        Flash::success('Session Txn deleted successfully.');

        return redirect(route('sessionTxns.index'));
    }
}
