<?php

namespace App\Http\Controllers;

use App\DataTables\ResponseDataTable;
use App\Exports\UserResponsesExport;
use App\Http\Requests;
use App\Http\Requests\CreateResponseRequest;
use App\Http\Requests\UpdateResponseRequest;
use App\Models\Question;
use App\Models\Response;
use App\Models\SentSurveys;
use App\Models\SurveyType;
use App\Repositories\ResponseRepository;
use App\Models\Template;
use App\Repositories\SentSurveysRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Maatwebsite\Excel\Facades\Excel;
use Response as HttpResponse;
use function foo\func;

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

//    public function show($template_id)
//    {
//
//    }

    public function show($template_id)
    {
        $responses = Question::where('template_id',$template_id)
            ->with(['answer','responses'])
            ->paginate(5);

        $template = Template::with('surveyType')->find($template_id);

        if ($template->surveyType->status == 1) {
            $questions = Question::where('template_id', $template_id)->with('responses')->get();
//            $respondents = Response::where('template_id', $template_id)->groupBy('survey_uuid')->get()->count();
            foreach ($questions as $que_resp) {
                $respondents = count($que_resp->responses);
                $ave = $que_resp->responses->reduce(function ($acc, $item) {
                    return $item['total_responses'] = $acc + $item->answer;

                });

            }
            foreach ($questions as $que_resp) {
                $tot_resp = Response::where('template_id', $template_id)->groupBy('survey_uuid')->get()->count();
                $total_responses = $que_resp->responses->reduce(function ($acc, $item) {
                    return $item['total_average'] = $acc + $item->total;
                });
            }
            return view('responses.evaluation', [
                'responses' => $responses,
                'id' => $template_id,
                'template' => $template,
                'average' => $ave,
                'respondents' => $respondents,
                'questions' => $questions,
                'tot_resp' => $tot_resp,
                'total_response' => $total_responses
            ]);
        }else
        return  view('responses.show',[
            'responses' => $responses,
            'id' => $template_id,
            'template' => $template
        ]);

        }



    public function exportResponses($id)
    {
        $export = new UserResponsesExport($id);
        return Excel::download($export, 'responses.xlsx');
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
