<?php

namespace App\Http\Controllers;

use App\Models\Answer;
use App\DataTables\QuestionDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateQuestionRequest;
use App\Http\Requests\UpdateQuestionRequest;
use App\Models\Question;
use App\Models\SurveyType;
use App\Models\Template;
use App\Repositories\AnswerRepository;
use App\Repositories\QuestionRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Illuminate\Support\Facades\Input;
use Response;

class QuestionController extends AppBaseController
{
    /** @var  QuestionRepository */
    private $questionRepository;
    private $answerRepository;

    public function __construct(QuestionRepository $questionRepo, AnswerRepository $answerRepository)
    {
        $this->questionRepository = $questionRepo;
        $this->answerRepository = $answerRepository;


    }

    /**
     * Display a listing of the Question.
     *
     * @param QuestionDataTable $questionDataTable
     * @return Response
     */
    public function index(QuestionDataTable $questionDataTable)
    {

        return $questionDataTable->render('questions.index');
    }

    /**
     * Show the form for creating a new Question.
     *
     * @return Response
     */
    public function create($id)
    {
        $template = Template::with('surveyType')->find($id);

        $questions = Question::ByTemplate($id)->get();
        $surveyType = SurveyType::get();
        return view('questions.index', ['template_id' => $id,
            'questions' => $questions,
            'template' => $template,
            'surveyType' => $surveyType]);
    }

    /**
     * Store a newly created Question in storage.
     *
     * @param CreateQuestionRequest $request
     *
     * @return Response
     */
    public function store(CreateQuestionRequest $request)
    {
        $input = $request->all();
        if (Input::hasFile('attachment')) {
            $name = trim($request->file('attachment')->getClientOriginalName());
            $destinationPath = 'uploads';
            $request->file('attachment')->move($destinationPath, $name);
            $input['attachment'] = $name;
        }

        $question = $this->questionRepository->create($input);

        if (($question['type'] == Question::SELECT_MULTIPLE OR $question['type'] == Question::DROP_DOWN_LIST)) {
            if (empty($input['options'])) {
                flash('A select Question must have choices')->error();
                return redirect()->back()->withInput();
            }
            foreach ($input['options'] as $choice) {
                $this->answerRepository->saveMultipleAnswers($question->id, $choice);

            }

        }

        Flash::success('Question saved successfully.');

        return redirect(url('questions', ['id' => $request->template_id]));
    }

    /**
     * Display the specified Question.
     *
     * @param int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $question = $this->questionRepository->find($id);

        if (empty($question)) {
            Flash::error('Question not found');

            return redirect(url('questions', ['id' => $question->template_id]));
        }

        return view('questions.show')->with(['question' => $question, 'template' => Template::find($question->template_id)]);
    }

    /**
     * Show the form for editing the specified Question.
     *
     * @param int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $question = $this->questionRepository->find($id);
        $template_id = $question->template_id;

        $template = Template::with('surveyType')->find($question->template_id);
        $surveyType = SurveyType::get();
        if (empty($question)) {
            Flash::error('Question not found');

            return redirect(url('questions', ['id' => $question->template_id]));
        }

        return view('questions.edit')->with(['question' => $question, 'template_id' => $template_id,
            'template' => $template, 'surveyType' => $surveyType]);
    }

    /**
     * Update the specified Question in storage.
     *
     * @param int $id
     * @param UpdateQuestionRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateQuestionRequest $request)
    {
        $question = $this->questionRepository->find($id);
        $template_id = $question->template_id;
        $input = $request->all();
        $input['status'] = $request->input('status') ? $request->input('status') : 0;
        if (empty($question)) {
            Flash::error('Question not found');

            return redirect(route('questions.index'));
        }

        $question = $this->questionRepository->update($input, $id);

        if (($question['type'] == Question::SELECT_MULTIPLE OR $question['type'] == Question::DROP_DOWN_LIST)) {
            if ((empty($request['options']))) {
                flash('A select Question must have choices')->error();

                return redirect()->back()->withInput();
            }

            foreach ($request['options'] as $key => $choice) {
                $answer_id = array_key_exists($key, $request['optionsId']) ? $request['optionsId'][$key] : null;
                $this->answerRepository->updateMultipleAnswers($question->id, $choice, $answer_id);
            }
        }

            Flash::success('Question updated successfully.');

            return redirect(url('questions', $template_id));


    }

    /**
     * Remove the specified Question from storage.
     *
     * @param int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $question = $this->questionRepository->find($id);

        if (empty($question)) {
            Flash::error('Question not found');

            return redirect(url('questions', ['id' => $question['template_id']]));

        }

        $this->questionRepository->delete($id);

        Flash::success('Question deleted successfully.');

        return redirect(url('questions', ['id' => $question->template_id]));
    }
}
