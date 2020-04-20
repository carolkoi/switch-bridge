<?php

namespace App\Http\Controllers;

use App\DataTables\PaybillDataTable;
use App\Http\Requests;
use App\Http\Requests\CreatePaybillRequest;
use App\Http\Requests\UpdatePaybillRequest;
use App\Repositories\PaybillRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class PaybillController extends AppBaseController
{
    /** @var  PaybillRepository */
    private $paybillRepository;

    public function __construct(PaybillRepository $paybillRepo)
    {
        $this->paybillRepository = $paybillRepo;
    }

    /**
     * Display a listing of the Paybill.
     *
     * @param PaybillDataTable $paybillDataTable
     * @return Response
     */
    public function index(PaybillDataTable $paybillDataTable)
    {
        return $paybillDataTable->render('paybills.index');
    }

    /**
     * Show the form for creating a new Paybill.
     *
     * @return Response
     */
    public function create()
    {
        return view('paybills.create');
    }

    /**
     * Store a newly created Paybill in storage.
     *
     * @param CreatePaybillRequest $request
     *
     * @return Response
     */
    public function store(CreatePaybillRequest $request)
    {
        $input = $request->all();

        $paybill = $this->paybillRepository->create($input);

        Flash::success('Paybill saved successfully.');

        return redirect(route('paybills.index'));
    }

    /**
     * Display the specified Paybill.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $paybill = $this->paybillRepository->find($id);

        if (empty($paybill)) {
            Flash::error('Paybill not found');

            return redirect(route('paybills.index'));
        }

        return view('paybills.show')->with('paybill', $paybill);
    }

    /**
     * Show the form for editing the specified Paybill.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $paybill = $this->paybillRepository->find($id);

        if (empty($paybill)) {
            Flash::error('Paybill not found');

            return redirect(route('paybills.index'));
        }

        return view('paybills.edit')->with('paybill', $paybill);
    }

    /**
     * Update the specified Paybill in storage.
     *
     * @param  int              $id
     * @param UpdatePaybillRequest $request
     *
     * @return Response
     */
    public function update($id, UpdatePaybillRequest $request)
    {
        $paybill = $this->paybillRepository->find($id);

        if (empty($paybill)) {
            Flash::error('Paybill not found');

            return redirect(route('paybills.index'));
        }

        $paybill = $this->paybillRepository->update($request->all(), $id);

        Flash::success('Paybill updated successfully.');

        return redirect(route('paybills.index'));
    }

    /**
     * Remove the specified Paybill from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $paybill = $this->paybillRepository->find($id);

        if (empty($paybill)) {
            Flash::error('Paybill not found');

            return redirect(route('paybills.index'));
        }

        $this->paybillRepository->delete($id);

        Flash::success('Paybill deleted successfully.');

        return redirect(route('paybills.index'));
    }
}
