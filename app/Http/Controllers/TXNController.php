<?php

namespace App\Http\Controllers;

use App\DataTables\TXNDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateTXNRequest;
use App\Http\Requests\UpdateTXNRequest;
use App\Repositories\TXNRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class TXNController extends AppBaseController
{
    /** @var  TXNRepository */
    private $tXNRepository;

    public function __construct(TXNRepository $tXNRepo)
    {
        $this->tXNRepository = $tXNRepo;
    }

    /**
     * Display a listing of the TXN.
     *
     * @param TXNDataTable $tXNDataTable
     * @return Response
     */
    public function index(TXNDataTable $tXNDataTable)
    {
        return $tXNDataTable->render('t_x_n_s.index');
    }

    /**
     * Show the form for creating a new TXN.
     *
     * @return Response
     */
    public function create()
    {
        return view('t_x_n_s.create');
    }

    /**
     * Store a newly created TXN in storage.
     *
     * @param CreateTXNRequest $request
     *
     * @return Response
     */
    public function store(CreateTXNRequest $request)
    {
        $input = $request->all();

        $tXN = $this->tXNRepository->create($input);

        Flash::success('T X N saved successfully.');

        return redirect(route('tXNS.index'));
    }

    /**
     * Display the specified TXN.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $tXN = $this->tXNRepository->find($id);

        if (empty($tXN)) {
            Flash::error('T X N not found');

            return redirect(route('tXNS.index'));
        }

        return view('t_x_n_s.show')->with('tXN', $tXN);
    }

    /**
     * Show the form for editing the specified TXN.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $tXN = $this->tXNRepository->find($id);

        if (empty($tXN)) {
            Flash::error('T X N not found');

            return redirect(route('tXNS.index'));
        }

        return view('t_x_n_s.edit')->with('tXN', $tXN);
    }

    /**
     * Update the specified TXN in storage.
     *
     * @param  int              $id
     * @param UpdateTXNRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateTXNRequest $request)
    {
        $tXN = $this->tXNRepository->find($id);

        if (empty($tXN)) {
            Flash::error('T X N not found');

            return redirect(route('tXNS.index'));
        }

        $tXN = $this->tXNRepository->update($request->all(), $id);

        Flash::success('T X N updated successfully.');

        return redirect(route('tXNS.index'));
    }

    /**
     * Remove the specified TXN from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $tXN = $this->tXNRepository->find($id);

        if (empty($tXN)) {
            Flash::error('T X N not found');

            return redirect(route('tXNS.index'));
        }

        $this->tXNRepository->delete($id);

        Flash::success('T X N deleted successfully.');

        return redirect(route('tXNS.index'));
    }
}
