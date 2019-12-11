<?php

namespace App\Jobs;

use App\Http\Controllers\Allocation\SendSurveyEmailController;
use App\Models\Template;
use Illuminate\Bus\Queueable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use App\Mail\SurveyEmail;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;

class SendSurveyEmailJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Create a new job instance.
     *
     * @return void
     */
    protected $template;
    protected $token;
    protected $email;
    protected $id;
    public function __construct(Template $template, $token, $email, $id)
    {
        $this->template = $template;
        $this->token = $token;
        $this->email = $email;
        $this->id = $id;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        Log::info("job dispached");
//      return app(SendSurveyEmailController::class)->emailSurvey($this->template->id);
        Mail::to($this->email)->send(new SurveyEmail($this->template, $this->token, $this->id));


    }
}
