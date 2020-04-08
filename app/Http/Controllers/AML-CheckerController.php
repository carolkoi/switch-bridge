<?php

namespace App\Http\Controllers;

use App\DataTables\AML-CheckerDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateAML-CheckerRequest;
use App\Http\Requests\UpdateAML-CheckerRequest;
use App\Repositories\AML-CheckerRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class AML-CheckerController extends AppBaseController
{
    /** @var  AML-CheckerRepository */
    private $aMLCheckerRepository;

    public function __construct(AML-CheckerRepository $aMLCheckerRepo)
    {
        $this->aMLCheckerRepository = $aMLCheckerRepo;
    }

    /**
     * Display a listing of the AML-Checker.
     *
     * @param AML-CheckerDataTable $aMLCheckerDataTable
     * @return Response
     */
    public function index(AML-CheckerDataTable $aMLCheckerDataTable)
    {
        return $aMLCheckerDataTable->render('a_m_l-_checkers.index');
    }

    /**
     * Show the form for creating a new AML-Checker.
     *
     * @return Response
     */
    public function create()
    {
        return view('a_m_l-_checkers.create');
    }

    /**
     * Store a newly created AML-Checker in storage.
     *
     * @param CreateAML-CheckerRequest $request
     *
     * @return Response
     */
    public function store(CreateAML-CheckerRequest $request)
    {
        $input = $request->all();

        $aMLChecker = $this->aMLCheckerRepository->create($input);

        Flash::success('A M L- Checker saved successfully.');

        return redirect(route('aMLCheckers.index'));
    }

    /**
     * Display the specified AML-Checker.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $aMLChecker = $this->aMLCheckerRepository->find($id);

        if (empty($aMLChecker)) {
            Flash::error('A M L- Checker not found');

            return redirect(route('aMLCheckers.index'));
        }

        return view('a_m_l-_checkers.show')->with('aMLChecker', $aMLChecker);
    }

    /**
     * Show the form for editing the specified AML-Checker.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $aMLChecker = $this->aMLCheckerRepository->find($id);

        if (empty($aMLChecker)) {
            Flash::error('A M L- Checker not found');

            return redirect(route('aMLCheckers.index'));
        }

        return view('a_m_l-_checkers.edit')->with('aMLChecker', $aMLChecker);
    }

    /**
     * Update the specified AML-Checker in storage.
     *
     * @param  int              $id
     * @param UpdateAML-CheckerRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateAML-CheckerRequest $request)
    {
        $aMLChecker = $this->aMLCheckerRepository->find($id);

        if (empty($aMLChecker)) {
            Flash::error('A M L- Checker not found');

            return redirect(route('aMLCheckers.index'));
        }

        $aMLChecker = $this->aMLCheckerRepository->update($request->all(), $id);

        Flash::success('A M L- Checker updated successfully.');

        return redirect(route('aMLCheckers.index'));
    }

    /**
     * Remove the specified AML-Checker from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $aMLChecker = $this->aMLCheckerRepository->find($id);

        if (empty($aMLChecker)) {
            Flash::error('A M L- Checker not found');

            return redirect(route('aMLCheckers.index'));
        }

        $this->aMLCheckerRepository->delete($id);

        Flash::success('A M L- Checker deleted successfully.');

        return redirect(route('aMLCheckers.index'));
    }
}
