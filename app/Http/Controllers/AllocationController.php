<?php

namespace App\Http\Controllers;

use App\DataTables\AllocationDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateAllocationRequest;
use App\Http\Requests\UpdateAllocationRequest;
use App\Mail\SendEmailQuestionnaire;
use App\Mail\SendSurveyEmail;
use App\Models\Allocation;
use App\Models\Client;
use App\Models\Template;
use App\Models\User;
use App\Repositories\AllocationRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Illuminate\Support\Facades\Mail;
use Response;
use Webpatser\Uuid\Uuid;

class AllocationController extends AppBaseController
{
    /** @var  AllocationRepository */
    private $allocationRepository;

    public function __construct(AllocationRepository $allocationRepo)
    {
        $this->allocationRepository = $allocationRepo;
    }

    /**
     * Display a listing of the Allocation.
     *
     * @param AllocationDataTable $allocationDataTable
     * @return Response
     */
    public function index(AllocationDataTable $allocationDataTable)
    {
//        dd(Allocation::with('template')->groupBy(['template_id'])->get()->toArray());
        return $allocationDataTable->render('allocations.index');
    }

    /**
     * Show the form for creating a new Allocation.
     *
     * @return Response
     */
    public function create()
    {
        $templates = Template::get();
        return view('allocations.create', ['templates' => $templates, 'users' => User::get(), 'clients' => Client::get()]);
    }

    /**
     * Store a newly created Allocation in storage.
     *
     * @param CreateAllocationRequest $request
     *
     * @return Response
     */
    public function store(CreateAllocationRequest $request)
    {
        $input = $request->except('user_id', 'client_id');
        $template = Template::findOrFail($input['template_id']);
        $users = $request->input('user_id');
        $clients = $request->input('client_id');
        if (is_array($users)){
        foreach ($users as $user) {
            $input['user_id'] = $user;
//            dd(array_diff($input, array($user)));
            $allocation = $this->allocationRepository->create($input);
            $staff_email = User::find($user)->email;
            $token = Uuid::generate()->string;
            Mail::to($staff_email)->send(new SendSurveyEmail($template, $token));
        }

        }
        if ($clients) {
            foreach ($clients as $client) {
                $input['client_id'] = $client;
                $allocation = $this->allocationRepository->create($input);
                $client_mail = Client::find($client)->email;
                //before send survey, generate unique uuid
                $token = Uuid::generate()->string;
                Mail::to($client_mail)->send(new SendSurveyEmail($template, $token));
            }
        }



        Flash::success('Survey allocated successfully.');

        return redirect(route('allocations.index'));
    }

    /**
     * Display the specified Allocation.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $allocation = $this->allocationRepository->find($id);

        if (empty($allocation)) {
            Flash::error('Allocation not found');

            return redirect(route('allocations.index'));
        }

        return view('allocations.show')->with('allocation', $allocation);
    }

    /**
     * Show the form for editing the specified Allocation.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $allocation = $this->allocationRepository->find($id);
        $template = Template::find($allocation->template_id);
        $user = User::find($allocation->user_id);
        $client = Client::find($allocation->client_id);
        $users = User::get();
        $clients = Client::get();

        if (empty($allocation)) {
            Flash::error('Allocation not found');

            return redirect(route('allocations.index'));
        }

        return view('allocations.edit', compact('allocation','template', 'users', 'clients', 'user', 'client'));
    }

    /**
     * Update the specified Allocation in storage.
     *
     * @param  int              $id
     * @param UpdateAllocationRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateAllocationRequest $request)
    {
        $allocation = $this->allocationRepository->find($id);
        $requestdata = $request->except(['user_id', 'client_id']);
        $template = Template::find($allocation->template_id);

        if (empty($allocation)) {
            Flash::error('Allocation not found');

            return redirect(route('allocations.index'));
        }
        if ($requestdata['user_type'] == 'staff'){
            $staffs = $request['user_id'];
            foreach ($staffs as $staff){
                $requestdata['user_id'] = $staff;
                $allocation = $this->allocationRepository->create($requestdata, $id);
                $staff_email = User::find($staff)->email;
                Mail::to($staff_email)->send(new SendSurveyEmail($template));

            }
        }
        if ($allocation->user_type == 'client'){
            $clients = $request->input('client_id');
            foreach ($clients as $client){
                $all_update['client_id'] = $client;
                $allocation = $this->allocationRepository->update($all_update, $id);
                $client_mail = Client::find($client)->email;
                Mail::to($client_mail)->send(new SendSurveyEmail($template));

            }
        }

        Flash::success('Survey allocation updated successfully.');

        return redirect(route('allocations.index'));
    }

    /**
     * Remove the specified Allocation from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $allocation = $this->allocationRepository->find($id);

        if (empty($allocation)) {
            Flash::error('Allocation not found');

            return redirect(route('allocations.index'));
        }

        $this->allocationRepository->delete($id);

        Flash::success('Allocation deleted successfully.');

        return redirect(route('allocations.index'));
    }
    public function getSurveyType($type){
        // Fetch survey by type
        $surveyData = Template::where('type', $type)->get()->pluck('name','id');
        return response()->json(['data' => $surveyData]);
    }


    public function approveSurvey($id, $action)
    {

        $allocation = Allocation::where('template_id',$id)->with(['template.questions'])->first();

        if(count($allocation->template->questions) > 0){
            if($action){

                $allocation->update(['status' => Allocation::APPROVED]);

                flash('Survey approved')->success();

            }else{
                $allocation->update(['status' => !Allocation::APPROVED]);
                flash('survey rejected')->success();

            }

            return redirect()->route('allocations.index');
        }

        flash('You cannot activate a survey with no questions')->error();
        return redirect()->route('allocations.index');
    }
}
