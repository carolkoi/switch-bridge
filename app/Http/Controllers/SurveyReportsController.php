<?php

namespace App\Http\Controllers;

use App\DataTables\SurveyReportsDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateSurveyReportsRequest;
use App\Http\Requests\UpdateSurveyReportsRequest;
use App\Models\Question;
use App\Models\Template;
use App\Repositories\AllocationRepository;
use App\Repositories\SurveyReportsRepository;
use App\User;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class SurveyReportsController extends AppBaseController
{
    /** @var  SurveyReportsRepository */
    private $surveyReportsRepository;
    private $allocationRepository;

    public function __construct(SurveyReportsRepository $surveyReportsRepo, AllocationRepository $allocationRepo)
    {
        $this->surveyReportsRepository = $surveyReportsRepo;
        $this->allocationRepository = $allocationRepo;
    }

    /**
     * Display a listing of the SurveyReports.
     *
     * @param SurveyReportsDataTable $surveyReportsDataTable
     * @return Response
     */
    public function index(SurveyReportsDataTable $surveyReportsDataTable)
    {
        return $surveyReportsDataTable->render('survey_reports.index');
    }

    /**
     * Show the form for creating a new SurveyReports.
     *
     * @return Response
     */
    public function create()
    {
        return view('survey_reports.create');
    }

    /**
     * Store a newly created SurveyReports in storage.
     *
     * @param CreateSurveyReportsRequest $request
     *
     * @return Response
     */
    public function store(CreateSurveyReportsRequest $request)
    {
        $input = $request->all();

        $surveyReports = $this->surveyReportsRepository->create($input);

        Flash::success('Survey Reports saved successfully.');

        return redirect(route('surveyReports.index'));
    }

    /**
     * Display the specified SurveyReports.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($template_id)
    {
        $surveyReport = Template::find($template_id);
       $questions = Question::where('template_id',$template_id )->get();

        if (empty($surveyReport)) {
            Flash::error('Survey Reports not found');

            return redirect(route('surveyReports.index'));
        }

        return view('survey_reports.show')->with(['surveyReport'=> $surveyReport,
            'questions' => $questions, 'user' => User::find($surveyReport->user_id)]);
    }

    /**
     * Show the form for editing the specified SurveyReports.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $surveyReports = $this->surveyReportsRepository->find($id);

        if (empty($surveyReports)) {
            Flash::error('Survey Reports not found');

            return redirect(route('surveyReports.index'));
        }

        return view('survey_reports.edit')->with('surveyReports', $surveyReports);
    }

    /**
     * Update the specified SurveyReports in storage.
     *
     * @param  int              $id
     * @param UpdateSurveyReportsRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateSurveyReportsRequest $request)
    {
        $surveyReports = $this->surveyReportsRepository->find($id);

        if (empty($surveyReports)) {
            Flash::error('Survey Reports not found');

            return redirect(route('surveyReports.index'));
        }

        $surveyReports = $this->surveyReportsRepository->update($request->all(), $id);

        Flash::success('Survey Reports updated successfully.');

        return redirect(route('surveyReports.index'));
    }

    /**
     * Remove the specified SurveyReports from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $surveyReports = $this->surveyReportsRepository->find($id);

        if (empty($surveyReports)) {
            Flash::error('Survey Reports not found');

            return redirect(route('surveyReports.index'));
        }

        $this->surveyReportsRepository->delete($id);

        Flash::success('Survey Reports deleted successfully.');

        return redirect(route('surveyReports.index'));
    }
}
