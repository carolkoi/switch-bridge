<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Float;
use Faker\Generator as Faker;

$factory->define(Float::class, function (Faker $faker) {

    return [
        'partnerid' => $faker->randomDigitNotNull,
        'description' => $faker->word,
        'transactionnumber' => $faker->word,
        'debit' => $faker->word,
        'credit' => $faker->word,
        'amount' => $faker->word,
        'runningbal' => $faker->word,
        'datetimeadded' => $faker->date('Y-m-d H:i:s'),
        'addedby' => $faker->randomDigitNotNull,
        'ipaddress' => $faker->word
    ];
});
