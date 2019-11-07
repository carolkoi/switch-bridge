<?php

namespace App\Http\Controllers\Allocation;

use App\Http\Controllers\Controller;
use App\Mail\SendSurveyEmail;
use App\Models\Allocation;
use App\Models\Client;
use App\Models\Template;
use App\Models\User;
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
        $now = new DateTime();
        $allocations = Allocation::where(['template_id' => $id, 'status' => true])->with('template')->get();
        foreach ($allocations as $allocation){
        if ($now < $allocation->template->valid_until) {

            $this->sendToClient($id);
            $this->sendToStaff($id);
            $this->sendToOther($id);
        }
            Flash::success('Survey email sent successfully.');
            return redirect(route('allocations.index'));
        }
        Flash::success('There is an error! Survey deadline has passed or the allocation is not yet approved.');
        return redirect(route('allocations.index'));
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
            Mail::to($staff_email)->send(new SendSurveyEmail($template, $token));
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
            Mail::to($client_email)->send(new SendSurveyEmail($template, $token));
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
            Mail::to($email)->send(new SendSurveyEmail($template, $token));
            Allocation::whereNull(['client_id', 'user_id'])->update(['email_sent' => 1]);
        }

    }
}
