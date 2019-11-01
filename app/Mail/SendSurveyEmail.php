<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;
use App\Models\Template;

class SendSurveyEmail extends Mailable
{
    use Queueable, SerializesModels;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public $template;
    public $token;

    public function __construct(Template $template, $token)
    {
        //
        $this->template = $template;
        $this->token = $token;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->view('allocations.email')
            ->with([
                'templateEmailMsg' => $this->template->email_msg,
                'templateID' => $this->template->id,
                'token' => $this->token
            ]);
    }
}
