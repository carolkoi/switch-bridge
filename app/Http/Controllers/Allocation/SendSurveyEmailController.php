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
    //
//    public function setEmailDelay(){
//        //Delaying email jobs
//        $baseDelay = json_encode(now());
//        $getDelay = json_encode(
//            cache('jobs.' . SendSurveyEmailJob::class, $baseDelay)
//        );
//        $setDelay = Carbon::parse(
//            $getDelay->date
//        )->addSeconds(10);
//
//        cache([
//            'jobs.' . SendSurveyEmailJob::class => json_encode($setDelay)
//        ], 5);
//        return;
//    }
    public function emailSurvey($id)
    {
        $setting = Options::where('option_name', 'automatic_survey_send')->first();
        $allocations = Allocation::where(['template_id' => $id, 'status' => true])->with('template')->get();

        foreach ($allocations as $allocation) {
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
            Flash::error($allocation->template->name. ' '.' survey already sent to these users.');
            return redirect(route('allocations.index'));
        }
        Flash::error('There is an error! The survey is not yet approved for allocation.');
        return redirect(route('allocations.index'));

    }

    public function sendToStaff($id)
    {
        $staffs = Allocation::where(['template_id' => $id, 'status' => true])
            ->whereNotNull('user_id')
            ->with(['template'])
            ->get();

        foreach ($staffs as $staff){
            $template = Template::find($staff->template_id);
            $staff_email = User::find($staff->user_id)->email;
            $token = Uuid::generate()->string;
//            Mail::to($staff_email)->send(new SurveyEmail($template, $token));
//            SendSurveyEmailJob::dispatch($template, new SurveyEmail($template, $token))->delay(1);
            $this->dispatch(new SendSurveyEmailJob($template,$token,$staff_email));
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
//            Mail::to($client_email)->send(new SurveyEmail($template, $token));
//            SendSurveyEmailJob::dispatch($template, new SurveyEmail($template, $token))->delay(1);
//            $this->dispatch(new SendSurveyEmailJob($template, $token));
//            $this->dispatch(new SendSurveyEmailJob());
            $this->dispatch(new SendSurveyEmailJob($template,$token,$client_email));
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
//            Mail::to($email)->send(new SurveyEmail($template, $token));
//            $this->dispatch(new SendSurveyEmailJob($template, $token));
//            SendSurveyEmailJob::dispatch(new SurveyEmail($template, $token))->delay(1);
//            $this->dispatch(new SendSurveyEmailJob());
            $this->dispatch(new SendSurveyEmailJob($template,$token,$email));
            Allocation::whereNull(['client_id', 'user_id'])->update(['email_sent' => 1]);
        }

    }
}
