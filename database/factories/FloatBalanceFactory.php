<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\FloatBalance;
use Faker\Generator as Faker;

$factory->define(FloatBalance::class, function (Faker $faker) {

    return [
        'description' => $faker->word,
        'transactionnumber' => $faker->word,
        'debit' => $faker->word,
        'credit' => $faker->word,
        'amount' => $faker->word,
        'runningbal' => $faker->word,
        'datetimeadded' => $faker->date('Y-m-d H:i:s'),
        'addedby' => $faker->randomDigitNotNull,
        'ipaddress' => $faker->word,
        'created_at' => $faker->word,
        'updated_at' => $faker->word,
        'deleted_at' => $faker->word,
        'partnerid' => $faker->word
    ];
});
