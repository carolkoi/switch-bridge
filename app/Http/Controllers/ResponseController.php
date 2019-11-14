<?php

namespace App\Http\Controllers;

use App\DataTables\ResponseDataTable;
use App\Exports\UserResponsesExport;
use App\Http\Requests;
use App\Http\Requests\CreateResponseRequest;
use App\Http\Requests\UpdateResponseRequest;
use App\Models\Question;
use App\Repositories\ResponseRepository;
use App\Models\Template;
use Flash;
use App\Http\Controllers\AppBaseController;
use Maatwebsite\Excel\Facades\Excel;
use Response;

class ResponseController extends AppBaseController
{
    /** @var  ResponseRepository */
    private $responseRepository;

    public function __construct(ResponseRepository $responseRepo)
    {
        $this->responseRepository = $responseRepo;
    }

    /**
     * Display a listing of the Response.
     *
     * @param ResponseDataTable $responseDataTable
     * @return Response
     */
    public function index(ResponseDataTable $responseDataTable)
    {
        return $responseDataTable->render('responses.index');
    }

    /**
     * Show the form for creating a new Response.
     *
     * @return Response
     */
    public function create()
    {
        return view('responses.create');
    }

    /**
     * Store a newly created Response in storage.
     *
     * @param CreateResponseRequest $request
     *
     * @return Response
     */
    public function store(CreateResponseRequest $request)
    {
        $input = $request->all();

        $response = $this->responseRepository->create($input);

        Flash::success('Response saved successfully.');

        return redirect(route('responses.index'));
    }

    public function show($template_id)
    {
//        $response = $this->responseRepository->find($template_id);
        $responses = Question::where('template_id',$template_id)
            ->with(['answer','responses'])
            ->get();
        $template = Template::find($template_id);


        return  view('responses.show',[
            'responses' => $responses,
            'id' => $template_id,
            'template' => $template
        ]);
    }

    public function exportResponses($id)
    {
//
        $template = Template::find($id);
        $export = new UserResponsesExport($template);

        return Excel::download($export, 'responses.xlsx');


//
    }

    /**
     * Display the specified Response.
     *
     * @param  int $id
     *
     * @return Response
     */
//    public function show($id)
//    {
//        $response = $this->responseRepository->find($id);
//
//        if (empty($response)) {
//            Flash::error('Response not found');
//
//            return redirect(route('responses.index'));
//        }
//
//        return view('responses.show')->with('response', $response);
//    }

    /**
     * Show the form for editing the specified Response.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $response = $this->responseRepository->find($id);

        if (empty($response)) {
            Flash::error('Response not found');

            return redirect(route('responses.index'));
        }

        return view('responses.edit')->with('response', $response);
    }

    /**
     * Update the specified Response in storage.
     *
     * @param  int              $id
     * @param UpdateResponseRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateResponseRequest $request)
    {
        $response = $this->responseRepository->find($id);

        if (empty($response)) {
            Flash::error('Response not found');

            return redirect(route('responses.index'));
        }

        $response = $this->responseRepository->update($request->all(), $id);

        Flash::success('Response updated successfully.');

        return redirect(route('responses.index'));
    }

    /**
     * Remove the specified Response from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $response = $this->responseRepository->find($id);

        if (empty($response)) {
            Flash::error('Response not found');

            return redirect(route('responses.index'));
        }

        $this->responseRepository->delete($id);

        Flash::success('Response deleted successfully.');

        return redirect(route('responses.index'));
    }
}
