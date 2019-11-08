<?php

namespace App\Console\Commands;

use App\Http\Controllers\Allocation\SendSurveyEmailController;
use App\Models\Template;
use Illuminate\Console\Command;
use App\Models\Allocation;
use App\Models\Options;

class automaticSurveySend extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'survey:send';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Sending surveys automatically to users';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        $templates = Template::get();
        foreach ($templates as $template){
            $id = $template->id;
        $allocations = Allocation::where('template_id', $id)->get();
        $setting = Options::find(1);
        if ($setting->value == true) {
            foreach ($allocations as $allocation){
                if ($allocation->email_sent == 0){
                    return app(SendSurveyEmailController::class)->emailSurvey($id);

                }
            }
        }

        }

    }
}
