<?php

namespace App\Http\Controllers;

use App\DataTables\CompDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateCompRequest;
use App\Http\Requests\UpdateCompRequest;
use App\Repositories\CompRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class CompController extends AppBaseController
{
    /** @var  CompRepository */
    private $compRepository;

    public function __construct(CompRepository $compRepo)
    {
        $this->compRepository = $compRepo;
    }

    /**
     * Display a listing of the Comp.
     *
     * @param CompDataTable $compDataTable
     * @return Response
     */
    public function index(CompDataTable $compDataTable)
    {
        return $compDataTable->render('comps.index');
    }

    /**
     * Show the form for creating a new Comp.
     *
     * @return Response
     */
    public function create()
    {
        return view('comps.create');
    }

    /**
     * Store a newly created Comp in storage.
     *
     * @param CreateCompRequest $request
     *
     * @return Response
     */
    public function store(CreateCompRequest $request)
    {
        $input = $request->all();

        $comp = $this->compRepository->create($input);

        Flash::success('Comp saved successfully.');

        return redirect(route('comps.index'));
    }

    /**
     * Display the specified Comp.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $comp = $this->compRepository->find($id);

        if (empty($comp)) {
            Flash::error('Comp not found');

            return redirect(route('comps.index'));
        }

        return view('comps.show')->with('comp', $comp);
    }

    /**
     * Show the form for editing the specified Comp.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $comp = $this->compRepository->find($id);

        if (empty($comp)) {
            Flash::error('Comp not found');

            return redirect(route('comps.index'));
        }

        return view('comps.edit')->with('comp', $comp);
    }

    /**
     * Update the specified Comp in storage.
     *
     * @param  int              $id
     * @param UpdateCompRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateCompRequest $request)
    {
        $comp = $this->compRepository->find($id);

        if (empty($comp)) {
            Flash::error('Comp not found');

            return redirect(route('comps.index'));
        }

        $comp = $this->compRepository->update($request->all(), $id);

        Flash::success('Comp updated successfully.');

        return redirect(route('comps.index'));
    }

    /**
     * Remove the specified Comp from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $comp = $this->compRepository->find($id);

        if (empty($comp)) {
            Flash::error('Comp not found');

            return redirect(route('comps.index'));
        }

        $this->compRepository->delete($id);

        Flash::success('Comp deleted successfully.');

        return redirect(route('comps.index'));
    }
}
