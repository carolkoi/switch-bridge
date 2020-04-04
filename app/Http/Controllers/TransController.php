<?php

namespace App\Http\Controllers;

use App\DataTables\TransDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateTransRequest;
use App\Http\Requests\UpdateTransRequest;
use App\Repositories\TransRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class TransController extends AppBaseController
{
    /** @var  TransRepository */
    private $transRepository;

    public function __construct(TransRepository $transRepo)
    {
        $this->transRepository = $transRepo;
    }

    /**
     * Display a listing of the Trans.
     *
     * @param TransDataTable $transDataTable
     * @return Response
     */
    public function index(TransDataTable $transDataTable)
    {
        return $transDataTable->render('trans.index');
    }

    /**
     * Show the form for creating a new Trans.
     *
     * @return Response
     */
    public function create()
    {
        return view('trans.create');
    }

    /**
     * Store a newly created Trans in storage.
     *
     * @param CreateTransRequest $request
     *
     * @return Response
     */
    public function store(CreateTransRequest $request)
    {
        $input = $request->all();

        $trans = $this->transRepository->create($input);

        Flash::success('Trans saved successfully.');

        return redirect(route('trans.index'));
    }

    /**
     * Display the specified Trans.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $trans = $this->transRepository->find($id);

        if (empty($trans)) {
            Flash::error('Trans not found');

            return redirect(route('trans.index'));
        }

        return view('trans.show')->with('trans', $trans);
    }

    /**
     * Show the form for editing the specified Trans.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $trans = $this->transRepository->find($id);

        if (empty($trans)) {
            Flash::error('Trans not found');

            return redirect(route('trans.index'));
        }

        return view('trans.edit')->with('trans', $trans);
    }

    /**
     * Update the specified Trans in storage.
     *
     * @param  int              $id
     * @param UpdateTransRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateTransRequest $request)
    {
        $trans = $this->transRepository->find($id);

        if (empty($trans)) {
            Flash::error('Trans not found');

            return redirect(route('trans.index'));
        }

        $trans = $this->transRepository->update($request->all(), $id);

        Flash::success('Trans updated successfully.');

        return redirect(route('trans.index'));
    }

    /**
     * Remove the specified Trans from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $trans = $this->transRepository->find($id);

        if (empty($trans)) {
            Flash::error('Trans not found');

            return redirect(route('trans.index'));
        }

        $this->transRepository->delete($id);

        Flash::success('Trans deleted successfully.');

        return redirect(route('trans.index'));
    }
}
