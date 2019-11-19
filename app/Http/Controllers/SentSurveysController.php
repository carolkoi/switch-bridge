<?php

namespace App\Http\Controllers;

use App\DataTables\SentSurveysDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateSentSurveysRequest;
use App\Http\Requests\UpdateSentSurveysRequest;
use App\Repositories\SentSurveysRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class SentSurveysController extends AppBaseController
{
    /** @var  SentSurveysRepository */
    private $sentSurveysRepository;

    public function __construct(SentSurveysRepository $sentSurveysRepo)
    {
        $this->sentSurveysRepository = $sentSurveysRepo;
    }

    /**
     * Display a listing of the SentSurveys.
     *
     * @param SentSurveysDataTable $sentSurveysDataTable
     * @return Response
     */
    public function index(SentSurveysDataTable $sentSurveysDataTable)
    {
        return $sentSurveysDataTable->render('sent_surveys.index');
    }

    /**
     * Show the form for creating a new SentSurveys.
     *
     * @return Response
     */
    public function create()
    {
        return view('sent_surveys.create');
    }

    /**
     * Store a newly created SentSurveys in storage.
     *
     * @param CreateSentSurveysRequest $request
     *
     * @return Response
     */
    public function store(CreateSentSurveysRequest $request)
    {
        $input = $request->all();

        $sentSurveys = $this->sentSurveysRepository->create($input);

        Flash::success('Sent Surveys saved successfully.');

        return redirect(route('sentSurveys.index'));
    }

    /**
     * Display the specified SentSurveys.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $sentSurveys = $this->sentSurveysRepository->find($id);

        if (empty($sentSurveys)) {
            Flash::error('Sent Surveys not found');

            return redirect(route('sentSurveys.index'));
        }

        return view('sent_surveys.show')->with('sentSurveys', $sentSurveys);
    }

    /**
     * Show the form for editing the specified SentSurveys.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $sentSurveys = $this->sentSurveysRepository->find($id);

        if (empty($sentSurveys)) {
            Flash::error('Sent Surveys not found');

            return redirect(route('sentSurveys.index'));
        }

        return view('sent_surveys.edit')->with('sentSurveys', $sentSurveys);
    }

    /**
     * Update the specified SentSurveys in storage.
     *
     * @param  int              $id
     * @param UpdateSentSurveysRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateSentSurveysRequest $request)
    {
        $sentSurveys = $this->sentSurveysRepository->find($id);

        if (empty($sentSurveys)) {
            Flash::error('Sent Surveys not found');

            return redirect(route('sentSurveys.index'));
        }

        $sentSurveys = $this->sentSurveysRepository->update($request->all(), $id);

        Flash::success('Sent Surveys updated successfully.');

        return redirect(route('sentSurveys.index'));
    }

    /**
     * Remove the specified SentSurveys from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $sentSurveys = $this->sentSurveysRepository->find($id);

        if (empty($sentSurveys)) {
            Flash::error('Sent Surveys not found');

            return redirect(route('sentSurveys.index'));
        }

        $this->sentSurveysRepository->delete($id);

        Flash::success('Sent Surveys deleted successfully.');

        return redirect(route('sentSurveys.index'));
    }
}
