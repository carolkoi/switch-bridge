<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\User;
use Faker\Generator as Faker;

$factory->define(User::class, function (Faker $faker) {

    return [
        'company_id' => $faker->randomDigitNotNull,
        'role_id' => $faker->randomDigitNotNull,
        'name' => $faker->word,
        'contact_person' => $faker->word,
        'email' => $faker->word,
        'password' => $faker->word,
        'msisdn' => $faker->word,
        'status' => $faker->word,
        'remember_token' => $faker->word,
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s')
    ];
});
