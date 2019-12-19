<?php

namespace App\Console\Commands;

use App\Models\ERPModels\Vendor;
use App\Models\Vendor as Supplier;
use Illuminate\Console\Command;

class VendorsCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'vendors:get';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Importing vendors from Sage';

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
        $vendors = Vendor::whereNotNull('EMail')->where('On_Hold', 0)->get();
        return collect($vendors)->each(function ($vendor){
                Supplier::updateOrCreate(
                [
                   'dc_link' => $vendor->DCLink,
//                    'email' => $vendor->EMail
                ],
                [
                    'account' => $vendor->Account,
                    'name' => $vendor->Name,
                    'contact_person' => $vendor->Contact_Person,
                    'physical1' => $vendor->Physical1,
                    'physical2' => $vendor->Physical2,
                    'physical3' => $vendor->Physical3,
                    'physical4' => $vendor->Physical4,
                    'physical5' => $vendor->Physical5,
                    'post1' => $vendor->Post1,
                    'post2' => $vendor->Post1,
                    'post3' => $vendor->Post1,
                    'post4' => $vendor->Post1,
                    'post5' => $vendor->Post1,
                    'tax_number' => $vendor->Tax_Number,
                    'email' => $vendor->EMail

                ]
            );

        });
        //
    }
}
