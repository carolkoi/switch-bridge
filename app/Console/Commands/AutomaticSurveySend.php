<?php

namespace App\Console\Commands;

use App\Http\Controllers\Allocation\SendSurveyEmailController;
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
        $allocations = Allocation::where('template_id', 6)->get();
        $setting = Options::find(1);
        if ($setting->value == true) {
            foreach ($allocations as $allocation){
                if ($allocation->email_sent == 0){
                    return app(SendSurveyEmailController::class)->emailSurvey(6);

                }
            }
        }


    }
}
