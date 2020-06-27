<?php

namespace App\Http\Controllers;

use App\DataTables\MessageTemplateDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateMessageTemplateRequest;
use App\Http\Requests\UpdateMessageTemplateRequest;
use App\Repositories\MessageTemplateRepository;
use App\Http\Controllers\AppBaseController;
use Carbon\Carbon;
use Flash;
use Illuminate\Contracts\View\Factory;
use Illuminate\Http\RedirectResponse;
use Illuminate\Routing\Redirector;
use Illuminate\Support\Facades\Auth;
use Illuminate\View\View;
use Response;

class MessageTemplateController extends AppBaseController
{
    /** @var  MessageTemplateRepository */
    private $messageTemplateRepository;

    public function __construct(MessageTemplateRepository $messageTemplateRepo)
    {
        $this->messageTemplateRepository = $messageTemplateRepo;
    }

    /**
     * Display a listing of the MessageTemplate.
     *
     * @param MessageTemplateDataTable $messageTemplateDataTable
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function index(MessageTemplateDataTable $messageTemplateDataTable)
    {
        return $messageTemplateDataTable->render('message_templates.index');
    }

    /**
     * Show the form for creating a new MessageTemplate.
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function create()
    {
        return view('message_templates.create');
    }

    /**
     * Store a newly created MessageTemplate in storage.
     *
     * @param CreateMessageTemplateRequest $request
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function store(CreateMessageTemplateRequest $request)
    {
        $input = $request->all();
        $input['datetimeadded'] = Carbon::now('Africa/Nairobi')->format('Y-m-d H:m:s.u');
        $input['addedby'] = Auth::id();
        $input['ipaddress'] = '::1';
        $input['partnerid'] = 0;
        $input['record_version'] = 0;

        $messageTemplate = $this->messageTemplateRepository->create($input);

        Flash::success('Message Template saved successfully.');

        return redirect(route('messageTemplates.index'));
    }

    /**
     * Display the specified MessageTemplate.
     *
     * @param  int $id
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function show($id)
    {
        $messageTemplate = $this->messageTemplateRepository->find($id);

        if (empty($messageTemplate)) {
            Flash::error('Message Template not found');

            return redirect(route('messageTemplates.index'));
        }

        return view('message_templates.show')->with('messageTemplate', $messageTemplate);
    }

    /**
     * Show the form for editing the specified MessageTemplate.
     *
     * @param  int $id
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function edit($id)
    {
        $messageTemplate = $this->messageTemplateRepository->find($id);

        if (empty($messageTemplate)) {
            Flash::error('Message Template not found');

            return redirect(route('messageTemplates.index'));
        }

        return view('message_templates.edit')->with('messageTemplate', $messageTemplate);
    }

    /**
     * Update the specified MessageTemplate in storage.
     *
     * @param  int              $id
     * @param UpdateMessageTemplateRequest $request
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function update($id, UpdateMessageTemplateRequest $request)
    {
//        dd('here');
        $messageTemplate = $this->messageTemplateRepository->find($id);

        if (empty($messageTemplate)) {
            Flash::error('Message Template not found');

            return redirect(route('messageTemplates.index'));
        }

        $messageTemplate = $this->messageTemplateRepository->update($request->all(), $id);

        Flash::success('Message Template updated successfully.');

        return redirect(route('messageTemplates.index'));
    }

    /**
     * Remove the specified MessageTemplate from storage.
     *
     * @param  int $id
     *
     * @return Response|Factory|RedirectResponse|Redirector|View
     */
    public function destroy($id)
    {
        $messageTemplate = $this->messageTemplateRepository->find($id);

        if (empty($messageTemplate)) {
            Flash::error('Message Template not found');

            return redirect(route('messageTemplates.index'));
        }

        $this->messageTemplateRepository->delete($id);

        Flash::success('Message Template deleted successfully.');

        return redirect(route('messageTemplates.index'));
    }
}
