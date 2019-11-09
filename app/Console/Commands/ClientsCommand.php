<?php

namespace App\Console\Commands;

use GuzzleHttp\Client as GuzzleClient;
use App\Models\Client;
use App\Models\ERPModels\RtblPeople;
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

        $data = RtblPeople::whereNotNull('email')->where('cModule', 'AR')->with(['client','rtblpeoplelinks'])->get();
        return collect($data)->each(function ($client) {
            Client::updateOrCreate([
                "email" => $client->email,
            ],
                [
                    'contact_id' => $client->contact_id,
                    'first_name' => $client->first_name,
                    'last_name' => $client->last_name,
                    'initials' => $client->initials,
                    'email' => $client->email,
                    'company_account'=> $client->company_account,
                    'company_id' => $client->company_id,
                    'company_name' => $client->company_name
                ]

            );

        });
    }


}
