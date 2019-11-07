<?php

namespace App\Console\Commands;

use GuzzleHttp\Client as GuzzleClient;
use App\Models\ERPModels\Client;
use Illuminate\Console\Command;

class ClientsCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'clients:get';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'importing clients from sage';

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

        $data = Client::whereNotNull('email')->get();
        dd($data);

    }


}
