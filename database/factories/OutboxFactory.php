<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Outbox;
use Faker\Generator as Faker;

$factory->define(Outbox::class, function (Faker $faker) {

    return [
        'messageid' => $faker->randomDigitNotNull,
        'messagetypeid' => $faker->randomDigitNotNull,
        'messagestatus' => $faker->word,
        'messagepriority' => $faker->randomDigitNotNull,
        'datetimesent' => $faker->date('Y-m-d H:i:s'),
        'datetimeadded' => $faker->date('Y-m-d H:i:s'),
        'addedby' => $faker->randomDigitNotNull,
        'ipaddress' => $faker->word,
        'attempts' => $faker->randomDigitNotNull,
        'record_version' => $faker->randomDigitNotNull,
        'created_at' => $faker->word,
        'updated_at' => $faker->word,
        'deleted_at' => $faker->word
    ];
});
