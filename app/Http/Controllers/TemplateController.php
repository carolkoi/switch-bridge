<?php

namespace App\Http\Controllers;

use App\DataTables\TemplateDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateTemplateRequest;
use App\Http\Requests\UpdateTemplateRequest;
use App\Models\Question;
use App\Models\Template;
use App\Repositories\TemplateRepository;
use App\User;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class TemplateController extends AppBaseController
{
    /** @var  TemplateRepository */
    private $templateRepository;

    public function __construct(TemplateRepository $templateRepo)
    {
        $this->templateRepository = $templateRepo;
    }

    /**
     * Display a listing of the Template.
     *
     * @param TemplateDataTable $templateDataTable
     * @return Response
     */
    public function index(TemplateDataTable $templateDataTable)
    {
//        dd(Template::with('questions')->get()->toArray());
        return $templateDataTable->render('templates.index');
    }

    /**
     * Show the form for creating a new Template.
     *
     * @return Response
     */
    public function create()
    {
        return view('templates.create');
    }

    /**
     * Store a newly created Template in storage.
     *
     * @param CreateTemplateRequest $request
     *
     * @return Response
     */
    public function store(CreateTemplateRequest $request)
    {
        $input = $request->all();
        $input['user_id'] = auth()->id();

        $template = $this->templateRepository->create($input);

        Flash::success('Survey saved successfully.');

        return redirect(route('templates.index'));
    }

    /**
     * Display the specified Template.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {

        $template = $this->templateRepository->find($id);

        $questions = Question::where('template_id',$template->id)->get();
        if (empty($template)) {
            Flash::error('Template not found');

            return redirect(route('templates.index'));
        }

        return view('templates.show')->with(['template' => $template, 'questions' => $questions,
            'user' => User::find($template->user_id)]);
    }

    /**
     * Show the form for editing the specified Template.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $template = $this->templateRepository->find($id);

        if (empty($template)) {
            Flash::error('Survey not found');

            return redirect(route('templates.index'));
        }

        return view('templates.edit')->with('template', $template);
    }

    /**
     * Update the specified Template in storage.
     *
     * @param  int              $id
     * @param UpdateTemplateRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateTemplateRequest $request)
    {
        $template = $this->templateRepository->find($id);

        if (empty($template)) {
            Flash::error('Template not found');

            return redirect(route('templates.index'));
        }

        $template = $this->templateRepository->update($request->all(), $id);

        Flash::success('Survey updated successfully.');

        return redirect(route('templates.index'));
    }

    /**
     * Remove the specified Template from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $template = $this->templateRepository->find($id);

        if (empty($template)) {
            Flash::error('Survey not found');

            return redirect(route('templates.index'));
        }

        $this->templateRepository->delete($id);

        Flash::success('Survey deleted successfully.');

        return redirect(route('templates.index'));
    }

    public function changeStatus($id, $action)
    {

        $template = Template::where('id',$id)->with(['questions'])->first();

        if(count($template->questions) > 0){
            if($action){

                $template->update(['status' => Template::ACTIVE]);
                flash('Survey approved')->success();

            }else{
                $template->update(['status' => !Template::ACTIVE]);
                flash('survey rejected')->success();

            }

            return redirect()->route('templates.index');
        }

        flash('You cannot activate a survey with no questions')->error();
        return redirect()->route('templates.index');
    }
}
