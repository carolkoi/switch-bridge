<?php

namespace App\Http\Controllers;

use App\DataTables\ResponseReportsDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateResponseReportsRequest;
use App\Http\Requests\UpdateResponseReportsRequest;
use App\Repositories\ResponseReportsRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class ResponseReportsController extends AppBaseController
{
    /** @var  ResponseReportsRepository */
    private $responseReportsRepository;

    public function __construct(ResponseReportsRepository $responseReportsRepo)
    {
        $this->responseReportsRepository = $responseReportsRepo;
    }

    /**
     * Display a listing of the ResponseReports.
     *
     * @param ResponseReportsDataTable $responseReportsDataTable
     * @return Response
     */
    public function index(ResponseReportsDataTable $responseReportsDataTable)
    {
        return $responseReportsDataTable->render('response_reports.index');
    }

    /**
     * Show the form for creating a new ResponseReports.
     *
     * @return Response
     */
    public function create()
    {
        return view('response_reports.create');
    }

    /**
     * Store a newly created ResponseReports in storage.
     *
     * @param CreateResponseReportsRequest $request
     *
     * @return Response
     */
    public function store(CreateResponseReportsRequest $request)
    {
        $input = $request->all();

        $responseReports = $this->responseReportsRepository->create($input);

        Flash::success('Response Reports saved successfully.');

        return redirect(route('responseReports.index'));
    }

    /**
     * Display the specified ResponseReports.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $responseReports = $this->responseReportsRepository->find($id);

        if (empty($responseReports)) {
            Flash::error('Response Reports not found');

            return redirect(route('responseReports.index'));
        }

        return view('response_reports.show')->with('responseReports', $responseReports);
    }

    /**
     * Show the form for editing the specified ResponseReports.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $responseReports = $this->responseReportsRepository->find($id);

        if (empty($responseReports)) {
            Flash::error('Response Reports not found');

            return redirect(route('responseReports.index'));
        }

        return view('response_reports.edit')->with('responseReports', $responseReports);
    }

    /**
     * Update the specified ResponseReports in storage.
     *
     * @param  int              $id
     * @param UpdateResponseReportsRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateResponseReportsRequest $request)
    {
        $responseReports = $this->responseReportsRepository->find($id);

        if (empty($responseReports)) {
            Flash::error('Response Reports not found');

            return redirect(route('responseReports.index'));
        }

        $responseReports = $this->responseReportsRepository->update($request->all(), $id);

        Flash::success('Response Reports updated successfully.');

        return redirect(route('responseReports.index'));
    }

    /**
     * Remove the specified ResponseReports from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $responseReports = $this->responseReportsRepository->find($id);

        if (empty($responseReports)) {
            Flash::error('Response Reports not found');

            return redirect(route('responseReports.index'));
        }

        $this->responseReportsRepository->delete($id);

        Flash::success('Response Reports deleted successfully.');

        return redirect(route('responseReports.index'));
    }
}
