<?php

namespace App\Http\Controllers\Allocation;

use App\DataTables\AllocationDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateAllocationRequest;
use App\Http\Requests\UpdateAllocationRequest;
use App\Mail\SendEmailQuestionnaire;
use App\Mail\SendSurveyEmail;
use App\Models\Allocation;
use App\Models\Client;
use App\Models\Question;
use App\Models\SurveyType;
use App\Models\Template;
use App\Models\User;
use App\Models\Vendor;
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
        $survey_type = SurveyType::get()->pluck('type', 'id');
        return view('allocations.create', ['templates' => $templates,
            'users' => User::get()->pluck('name', 'id'),
            'clients' => Client::get()->pluck('name', 'id'),
            'vendors' => Vendor::get()->pluck('name', 'id'),
            'survey_type' => $survey_type]);
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
        $input = $request->except('user_id', 'client_id', 'others', 'vendor_id', 'user_type');
        $users = $request->input('user_id');
        $clients = $request->input('client_id');
        $vendors = $request->input('vendor_id');
        $others = $request->input('others');
        $template = Template::where('id', $input['template_id'])->with('questions')->first();
        if (count($template->questions) > 0) {
            if (!empty($others)) {
                foreach ($others as $other) {
                    $input['others'] = serialize($other);
                    $input['user_id'] = null;
                    $input['client_id'] = null;
                    $input['vendor_id'] = null;
                    $input['user_type'] = 'other';
                    $allocation = $this->allocationRepository->create($input);
                }
                unset($input['others']);
            }
            if (!empty($users)) {
                foreach ($users as $user) {
                    $input['user_id'] = $user;
                    $input['others'] = null;
                    $input['client_id'] = null;
                    $input['vendor_id'] = null;
                    $input['user_type'] = 'staff';
                    $allocation = $this->allocationRepository->create($input);
                }
                unset($input['user_id']);
            }
            if (!empty($clients)) {
                foreach ($clients as $client) {
                    $input['client_id'] = $client;
                    $input['user_id'] = null;
                    $input['others'] = null;
                    $input['vendor_id'] = null;
                    $input['user_type'] = 'client';
                    $allocation = $this->allocationRepository->create($input);
                }
            }
            if (!empty($vendors)) {
                foreach ($vendors as $vendor) {
                    $input['vendor_id'] = $vendor;
                    $input['client_id'] = null;
                    $input['user_id'] = null;
                    $input['others'] = null;
                    $input['user_type'] = 'supplier';
                    $allocation = $this->allocationRepository->create($input);
                }
            }

            //initiating the approval request
            $allocations = Template::find($input['template_id']);
            $approval = new Template();
            $approval->addApproval($allocations);

            Flash::success('Survey allocated successfully.');
            return redirect(route('allocations.index'));
        }
        flash('You cannot allocate a survey with no questions')->error();
        return redirect()->route('allocations.index');
    }

    /**
     * Display the specified Allocation.
     *
     * @param int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $template = Template::with(['allocations.user', 'allocations.client'])->find($id);
        $questions = Question::where('template_id',$id)->get();
        $selected_users = $this->getAllocatedUsers($template->allocations);
        $selected_clients = $this->getAllocatedClients($template->allocations);
        $selected_mails = $this->getAllocatedMails($template->allocations);
        $allocation['selected_users'] = $selected_users;
        $allocation['selected_clients'] = $selected_clients;
        $allocation['selected_mails'] = $selected_mails;


        return view('allocations.show')->with(['allocation' => $allocation,
            'template' => $template, 'user' => User::find($template->user_id), 'questions' => $questions]);
    }

    private function getAllocatedUsers($allocation)
    {
        return collect($allocation)->filter(function ($allocation) {
            return !empty($allocation->user_id);
        })->map(function ($allocation){
            return $allocation->user_id;
        });

    }

    private function getAllocatedClients($allocation){
        return collect($allocation)->filter(function ($allocation) {
            return !empty($allocation->client_id);
        })->map(function ($allocation){
            return $allocation->client_id;
        });
    }

    private function getAllocatedMails($allocation){
        return collect($allocation)->filter(function ($allocation) {
            return !empty($allocation->others);
        })->map(function ($allocation){
            return [
            unserialize($allocation->others) => unserialize($allocation->others)
        ];
        });
    }

    private function getAllocatedVendors($allocation){
        return collect($allocation)->filter(function ($allocation){
            return !empty($allocation->vendor_id);
        })->map(function ($allocation){
            return $allocation->vendor_id;
        });
    }

    /**
     * Show the form for editing the specified Allocation.
     *
     * @param int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $template = Template::with(['allocations'])->find($id);
        $selected_users = $this->getAllocatedUsers($template->allocations);
        $selected_clients = $this->getAllocatedClients($template->allocations);
        $selected_mails = $this->getAllocatedMails($template->allocations);
        $selected_vendors = $this->getAllocatedVendors($template->allocations);

        $allocation['selected_users'] = $selected_users;
        $allocation['selected_clients'] = $selected_clients;
        $allocation['selected_mails'] = $selected_mails;
        $allocation['selected_vendors'] = $selected_vendors;
        $allocation['template_id']= (int)$id;
        $allocation['survey_type_id']= $template->survey_type_id;
//        dd($allocation['selected_mails'], $allocation['selected_clients'], $allocation['selected_users']);

        $users = User::get()->pluck('name', 'id');
        $clients = Client::get()->pluck('name', 'id');
        $vendors = Vendor::get()->pluck('name', 'id');
        $survey_type = SurveyType::get()->pluck('type', 'id');
        $templates = Template::where('survey_type_id', $template->survey_type_id)->get()->pluck('name', 'id');

        if (empty($allocation)) {
            Flash::error('Allocation not found');

            return redirect(route('allocations.index'));
        }

        return view('allocations.edit', ['allocation' => $allocation, 'template' => $template,
            'users' => $users, 'clients' => $clients, 'survey_type' => $survey_type,
            'templates' => $templates, 'vendors' => $vendors]);
    }

    /**
     * Update the specified Allocation in storage.
     *
     * @param int $id
     * @param UpdateAllocationRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateAllocationRequest $request)
    {

        $template = Template::with(['allocations'])->find($id);
        foreach($template->allocations as $allocation){
            $this->allocationRepository->delete($allocation->id);
        }
        $input = $request->except('user_id', 'client_id', 'others', 'vendor_id', 'user_type');
        $users = $request->input('user_id');
        $clients = $request->input('client_id');
        $vendors = $request->input('vendor_id');
        $others = $request->input('others');
            if (!empty($others)) {
                foreach ($others as $other) {
                    $input['others'] = serialize($other);
                    $input['user_id'] = null;
                    $input['client_id'] = null;
                    $input['vendor_id'] = null;
                    $input['user_type'] = 'other';
                    $allocation = $this->allocationRepository->create($input);
                }
                unset($input['others']);
            }
            if (!empty($users)) {
                foreach ($users as $user) {
                    $input['user_id'] = $user;
                    $input['others'] = null;
                    $input['client_id'] = null;
                    $input['vendor_id'] = null;
                    $input['user_type'] = 'staff';
                    $allocation = $this->allocationRepository->create($input);
                }
                unset($input['user_id']);
            }
            if (!empty($clients)) {
                foreach ($clients as $client) {
                    $input['client_id'] = $client;
                    $input['user_id'] = null;
                    $input['others'] = null;
                    $input['vendor_id'] = null;
                    $input['user_type'] = 'client';
                    $allocation = $this->allocationRepository->create($input);
                }
            }
            if (!empty($vendors)) {
                foreach ($vendors as $vendor) {
                    $input['vendor_id'] = $vendor;
                    $input['client_id'] = null;
                    $input['user_id'] = null;
                    $input['others'] = null;
                    $input['user_type'] = 'supplier';
                    $allocation = $this->allocationRepository->create($input);
                }
            }
            Flash::success('Survey allocation updated successfully.');
            return redirect(route('allocations.index'));
    }
    /**
     * Remove the specified Allocation from storage.
     *
     * @param int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $template = Template::with(['allocations'])->find($id);
        foreach($template->allocations as $allocation){
            $this->allocationRepository->delete($allocation->id);
        }


        Flash::success('Allocation deleted successfully.');

        return redirect(route('allocations.index'));
    }

    public function getSurveyType($type)
    {
        // Fetch survey by type
        $surveyData = Template::where('survey_type_id', $type)->get()->pluck('name', 'id');
        return response()->json(['data' => $surveyData]);
    }


    public function approveSurvey($id, $action)
    {

        $allocations = Template::find($id);
        $approval = new Template();
        $approval->addApproval($allocations);


        return redirect()->route('allocations.index');
    }


}
