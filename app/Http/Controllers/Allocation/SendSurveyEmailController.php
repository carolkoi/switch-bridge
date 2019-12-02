<?php

namespace App\Http\Controllers\Allocation;

use App\Http\Controllers\Controller;
use App\Mail\SurveyEmail;
use App\Jobs\SendSurveyEmailJob;
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
    public function emailSurvey($id)
    {
        $now = Carbon::now()->addMinute(1);
        $setting = Options::where('option_name', 'automatic_survey_send')->first();
        $allocations = Allocation::where(['template_id' => $id])->with('template')->get();
        foreach ($allocations as $allocation) {
            if ($allocation->template->approved == 1){
            if ($allocation->email_sent == 0) {
                if (Carbon::now()->lte($allocation->template->valid_until)) {
                    $this->sendToClient($id);
                    $this->sendToStaff($id);
                    $this->sendToOther($id);
                    Flash::success('Survey email sent successfully.');
                    return redirect(route('allocations.index'));
                }
                Flash::error('There is an error! Survey deadline has passed.');
                return redirect(route('allocations.index'));
            }
            Flash::error($allocation->template->name . ' ' . ' survey already sent to these users.');
            return redirect(route('allocations.index'));
        }
        }
        Flash::error('There is an error! The survey is not yet approved for allocation.');
        return redirect(route('allocations.index'));

    }

    public function sendToStaff($id)
    {
        $now = Carbon::now()->addMinute(1);
        $staffs = Allocation::where(['template_id' => $id])
            ->whereNotNull('user_id')
            ->with(['template'])
            ->get();


        foreach ($staffs as $staff){
            $template = Template::find($staff->template_id);
            $staff_email = User::find($staff->user_id)->email;
            $token = Uuid::generate()->string;
            $this->dispatch((new SendSurveyEmailJob($template,$token,$staff_email))->delay($now));
            Allocation::where('user_id', $staff->user_id)->update(['email_sent' => 1]);

        }

    }

    public function sendToClient($id)
    {
        $now = Carbon::now()->addMinute(1);
        $clients = Allocation::where(['template_id' => $id])
            ->whereNotNull('client_id')
            ->with('template')
            ->get();
        foreach ($clients as $client){
            $template = Template::find($client->template_id);
            $client_email = Client::find($client->client_id)->email;
            $token = Uuid::generate()->string;
            $this->dispatch((new SendSurveyEmailJob($template,$token,$client_email))->delay($now));
            Allocation::where('client_id', $client->client_id)->update(['email_sent' => 1]);

        }

    }

    public function sendToOther($id)
    {
        $now = Carbon::now()->addMinute(1);
        $others = Allocation::where(['template_id' => $id])
            ->whereNotNull('others')
            ->with('template')
            ->get();
        foreach ($others as $other){
            $template = Template::find($other->template_id);
            $email = unserialize($other->others);
            $token = Uuid::generate()->string;
            $this->dispatch((new SendSurveyEmailJob($template,$token,$email))->delay($now));
            Allocation::where(['others', serialize($other->others)])->update(['email_sent' => 1]);
        }

    }
}
