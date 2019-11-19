<?php

namespace App\Http\Controllers;

use App\DataTables\SurveyTypeDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateSurveyTypeRequest;
use App\Http\Requests\UpdateSurveyTypeRequest;
use App\Repositories\SurveyTypeRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class SurveyTypeController extends AppBaseController
{
    /** @var  SurveyTypeRepository */
    private $surveyTypeRepository;

    public function __construct(SurveyTypeRepository $surveyTypeRepo)
    {
        $this->surveyTypeRepository = $surveyTypeRepo;
    }

    /**
     * Display a listing of the SurveyType.
     *
     * @param SurveyTypeDataTable $surveyTypeDataTable
     * @return Response
     */
    public function index(SurveyTypeDataTable $surveyTypeDataTable)
    {
        return $surveyTypeDataTable->render('survey_types.index');
    }

    /**
     * Show the form for creating a new SurveyType.
     *
     * @return Response
     */
    public function create()
    {
        return view('survey_types.create');
    }

    /**
     * Store a newly created SurveyType in storage.
     *
     * @param CreateSurveyTypeRequest $request
     *
     * @return Response
     */
    public function store(CreateSurveyTypeRequest $request)
    {
        $input = $request->all();

        $surveyType = $this->surveyTypeRepository->create($input);

        Flash::success('Survey Type saved successfully.');

        return redirect(route('surveyTypes.index'));
    }

    /**
     * Display the specified SurveyType.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $surveyType = $this->surveyTypeRepository->find($id);

        if (empty($surveyType)) {
            Flash::error('Survey Type not found');

            return redirect(route('surveyTypes.index'));
        }

        return view('survey_types.show')->with('surveyType', $surveyType);
    }

    /**
     * Show the form for editing the specified SurveyType.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $surveyType = $this->surveyTypeRepository->find($id);

        if (empty($surveyType)) {
            Flash::error('Survey Type not found');

            return redirect(route('surveyTypes.index'));
        }

        return view('survey_types.edit')->with('surveyType', $surveyType);
    }

    /**
     * Update the specified SurveyType in storage.
     *
     * @param  int              $id
     * @param UpdateSurveyTypeRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateSurveyTypeRequest $request)
    {
        $surveyType = $this->surveyTypeRepository->find($id);

        if (empty($surveyType)) {
            Flash::error('Survey Type not found');

            return redirect(route('surveyTypes.index'));
        }

        $surveyType = $this->surveyTypeRepository->update($request->all(), $id);

        Flash::success('Survey Type updated successfully.');

        return redirect(route('surveyTypes.index'));
    }

    /**
     * Remove the specified SurveyType from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $surveyType = $this->surveyTypeRepository->find($id);

        if (empty($surveyType)) {
            Flash::error('Survey Type not found');

            return redirect(route('surveyTypes.index'));
        }

        $this->surveyTypeRepository->delete($id);

        Flash::success('Survey Type deleted successfully.');

        return redirect(route('surveyTypes.index'));
    }
}
