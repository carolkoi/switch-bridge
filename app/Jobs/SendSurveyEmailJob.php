<?php

namespace App\Jobs;

use App\Http\Controllers\Allocation\SendSurveyEmailController;
use App\Models\Template;
use Illuminate\Bus\Queueable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use App\Mail\SurveyEmail;

class SendSurveyEmailJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Create a new job instance.
     *
     * @return void
     */
    public $template;
    public $token;
    public $id;
    public function __construct(Template $template, $token, $id)
    {
        $this->template = $template;
        $this->token = $token;
        $this->id = $id;
    }

    /**
     * Execute the job.
     *
     * @param $id
     * @return void
     */
    public function handle($id)
    {
      return app(SendSurveyEmailController::class)->emailSurvey($id);


    }
}
