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

        $data = RtblPeople::whereNotNull('cEmail')->with(['peopleClient', 'rtblpeoplelink'])->get();
//        dd($data);
        return collect($data)->each(function ($client) {
            Client::updateOrCreate([
                "email" => $client->cEmail,
            ],
                [
                    'contact_id' => $client->idPeople,
                    'first_name' => $client->cFirstName,
                    'last_name' => $client->cLastName,
                    'initials' => $client->cInitials,
                    'email' => $client->cEmail,
                    'company_account'=> $client->peopleClient['Account'],
                    'company_id' => $client->peopleClient['DCLink'],
                    'company_name' => $client->peopleClient['Name']
                ]

            );

        });
    }


}
