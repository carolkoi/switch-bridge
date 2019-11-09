<?php

namespace App\Console\Commands;

use App\Http\Controllers\SurveyController;
use App\Http\Requests\CreateSurveyRequest;
use App\Http\Requests;
use App\Models\Options;
use Illuminate\Console\Command;

class ReceiveLateResponseCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'response:receive';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Receive responses after deadline';

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

    }
}
