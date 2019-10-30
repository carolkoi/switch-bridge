<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Client;
use Faker\Generator as Faker;

$factory->define(Client::class, function (Faker $faker) {

    return [
        'id' => $faker->numberBetween(1,20),
        'contact_id' => $faker->randomDigitNotNull,
        'first_name' => $faker->firstName,
        'last_name' => $faker->lastName,
        'initials' => $faker->word,
        'email' => $faker->email,
        'company_account' => $faker->numberBetween('10000', 90000),
        'company_id' => $faker->randomDigitNotNull,
        'company_name' => $faker->name,
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s'),
        'deleted_at' => $faker->date('Y-m-d H:i:s')
    ];
});
