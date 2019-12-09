<?php

namespace App\Http\Controllers;

use App\DataTables\OptionsDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateOptionsRequest;
use App\Http\Requests\UpdateOptionsRequest;
use App\Models\Options;
use App\Repositories\OptionsRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;

class OptionsController extends AppBaseController
{
    /** @var  OptionsRepository */
    private $optionsRepository;

    public function __construct(OptionsRepository $optionsRepo)
    {
        $this->optionsRepository = $optionsRepo;
    }

    /**
     * Display a listing of the Options.
     *
     * @param OptionsDataTable $optionsDataTable
     * @return Response
     */
    public function index()
    {
        $settings = Options::all();
//        dd($settings);
        return view('options.index', compact('settings'));
    }


    /**
     * Show the form for creating a new Options.
     *
     * @return Response
     */
    public function create()
    {
        return view('options.create');
    }

    /**
     * Store a newly created Options in storage.
     *
     * @param CreateOptionsRequest $request
     *
     * @return Response
     */
    public function store(CreateOptionsRequest $request)
    {
//        dd($request->all());
        $this->automateSurveysending( $request);
        $this->receiveLateResponses( $request);


        Flash::success('Setting question saved successfully.');
        return redirect()->back()->withInput();

        return redirect(route('options.index'));
    }
    public function automateSurveysending(CreateOptionsRequest $request){
        $input = $request->all();
        $automaticSurveySend = $request->get('automatic_survey_send');

        Options::where('option_name', 'automatic_survey_send' )->update(['value'=>$automaticSurveySend]);


    }

    public function receiveLateResponses(CreateOptionsRequest $request){
        $input = $request->all();
        $receiveLateResponse = $request->get('receive_late_response');

        Options::where('option_name', 'receive_late_response' )->update(['value'=>$receiveLateResponse]);

}


    /**
     * Remove the specified Options from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $options = $this->optionsRepository->find($id);

        if (empty($options)) {
            Flash::error('Options not found');

            return redirect(route('options.index'));
        }

        $this->optionsRepository->delete($id);

        Flash::success('Options deleted successfully.');

        return redirect(route('options.index'));
    }
}
