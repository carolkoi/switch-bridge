<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Provider;
use Faker\Generator as Faker;

$factory->define(Provider::class, function (Faker $faker) {

    return [
        'companyid' => $faker->randomDigitNotNull,
        'moneyservicename' => $faker->word,
        'provideridentifier' => $faker->randomDigitNotNull,
        'accountnumber' => $faker->word,
        'serviceprovidercategoryid' => $faker->randomDigitNotNull,
        'cutofflimit' => $faker->word,
        'settlementaccount' => $faker->word,
        'b2cbalance' => $faker->word,
        'c2bbalance' => $faker->word,
        'processingmode' => $faker->word,
        'addedby' => $faker->randomDigitNotNull,
        'serviceprovidertype' => $faker->word,
        'status' => $faker->word,
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s'),
        'deleted_at' => $faker->date('Y-m-d H:i:s')
    ];
});
