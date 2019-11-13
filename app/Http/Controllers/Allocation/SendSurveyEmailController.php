<?php

namespace App\Http\Controllers\Allocation;

use App\Http\Controllers\Controller;
use App\Mail\SurveyEmail;
use App\Models\Allocation;
use App\Models\Client;
use App\Models\Options;
use App\Models\Template;
use App\Models\User;
use Carbon\Carbon;
use DateTime;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Laracasts\Flash\Flash;
use Webpatser\Uuid\Uuid;

class SendSurveyEmailController extends Controller
{
    //
    public function emailSurvey($id)
    {
        $setting = Options::where('option_name', 'automatic_survey_send')->first();
        $allocations = Allocation::where(['template_id' => $id, 'status' => true])->with('template')->get();
        foreach ($allocations as $allocation){
        if (Carbon::now()->lte($allocation->template->valid_until)) {
            $this->sendToClient($id);
            $this->sendToStaff($id);
            $this->sendToOther($id);
            Flash::success('Survey email sent successfully.');
            return redirect(route('allocations.index'));
        }
            Flash::success('There is an error! Survey deadline has passed or the survey is not yet approved for allocation.');
            return redirect(route('allocations.index'));
        }

    }

    public function sendToStaff($id)
    {
        $staffs = Allocation::where(['template_id' => $id, 'status' => true])
            ->whereNotNull('user_id')
            ->with('template')
            ->get();

        foreach ($staffs as $staff){
            $template = Template::find($staff->template_id);
            $staff_email = User::find($staff->user_id)->email;
            $token = Uuid::generate()->string;
            Mail::to($staff_email)->send(new SurveyEmail($template, $token));
            Allocation::where('user_id', $staff->user_id)->update(['email_sent' => 1]);
        }

    }

    public function sendToClient($id)
    {
        $clients = Allocation::where(['template_id' => $id, 'status' => true])
            ->whereNotNull('client_id')
            ->with('template')
            ->get();
        foreach ($clients as $client){
            $template = Template::find($client->template_id);
            $client_email = Client::find($client->client_id)->email;
            $token = Uuid::generate()->string;
            Mail::to($client_email)->send(new SurveyEmail($template, $token));
            Allocation::where('client_id', $client->client_id)->update(['email_sent' => 1]);
        }

    }

    public function sendToOther($id)
    {
        $others = Allocation::where(['template_id' => $id, 'status' => true])
            ->whereNotNull('others')
            ->with('template')
            ->get();
        foreach ($others as $other){
            $template = Template::find($other->template_id);
            $email = unserialize($other->others);
            $token = Uuid::generate()->string;
            Mail::to($email)->send(new SurveyEmail($template, $token));
            Allocation::whereNull(['client_id', 'user_id'])->update(['email_sent' => 1]);
        }

    }
}
