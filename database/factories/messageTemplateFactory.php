<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\MessageTemplate;
use Faker\Generator as Faker;

$factory->define(MessageTemplate::class, function (Faker $faker) {

    return [
        'messagetype' => $faker->word,
        'eng_message' => $faker->word,
        'kis_message' => $faker->word,
        'messagepriority' => $faker->randomDigitNotNull,
        'datetimeadded' => $faker->date('Y-m-d H:i:s'),
        'addedby' => $faker->randomDigitNotNull,
        'ipaddress' => $faker->word,
        'partnerid' => $faker->randomDigitNotNull,
        'record_version' => $faker->randomDigitNotNull,
        'created_at' => $faker->word,
        'updated_at' => $faker->word,
        'deleted_at' => $faker->word
    ];
});
