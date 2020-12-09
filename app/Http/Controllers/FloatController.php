<?php

namespace App\Http\Controllers;

use App\DataTables\FloatDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateFloatRequest;
use App\Http\Requests\UpdateFloatRequest;
use App\Repositories\FloatRepository;
use App\Http\Controllers\AppBaseController;
use Flash;
use Illuminate\Contracts\View\Factory;
use Illuminate\Http\RedirectResponse;
use Illuminate\Routing\Redirector;
use Illuminate\View\View;
use Response;

class FloatController extends AppBaseController
{
    /** @var  FloatRepository */
    private $floatRepository;

    public function __construct(FloatRepository $floatRepo)
    {
        $this->floatRepository = $floatRepo;
    }

    /**
     * Display a listing of the Float.
     *
     * @param FloatDataTable $floatDataTable
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function index(FloatDataTable $floatDataTable)
    {
        return $floatDataTable->render('floats.index');
    }

    /**
     * Show the form for creating a new Float.
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function create()
    {
        return view('floats.create');
    }

    /**
     * Store a newly created Float in storage.
     *
     * @param CreateFloatRequest $request
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function store(CreateFloatRequest $request)
    {
        $input = $request->all();

        $float = $this->floatRepository->create($input);

        Flash::success('Float saved successfully.');

        return redirect(route('floats.index'));
    }

    /**
     * Display the specified Float.
     *
     * @param  int $id
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function show($id)
    {
        $float = $this->floatRepository->find($id);

        if (empty($float)) {
            Flash::error('Float not found');

            return redirect(route('floats.index'));
        }

        return view('floats.show')->with('float', $float);
    }

    /**
     * Show the form for editing the specified Float.
     *
     * @param  int $id
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function edit($id)
    {
        $float = $this->floatRepository->find($id);

        if (empty($float)) {
            Flash::error('Float not found');

            return redirect(route('floats.index'));
        }

        return view('floats.edit')->with('float', $float);
    }

    /**
     * Update the specified Float in storage.
     *
     * @param  int              $id
     * @param UpdateFloatRequest $request
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function update($id, UpdateFloatRequest $request)
    {
        $float = $this->floatRepository->find($id);

        if (empty($float)) {
            Flash::error('Float not found');

            return redirect(route('floats.index'));
        }

        $float = $this->floatRepository->update($request->all(), $id);

        Flash::success('Float updated successfully.');

        return redirect(route('floats.index'));
    }

    /**
     * Remove the specified Float from storage.
     *
     * @param  int $id
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function destroy($id)
    {
        $float = $this->floatRepository->find($id);

        if (empty($float)) {
            Flash::error('Float not found');

            return redirect(route('floats.index'));
        }

        $this->floatRepository->delete($id);

        Flash::success('Float deleted successfully.');

        return redirect(route('floats.index'));
    }
}
