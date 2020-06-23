<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Message;
use Faker\Generator as Faker;

$factory->define(Message::class, function (Faker $faker) {

    return [
        'messagetypeid' => $faker->randomDigitNotNull,
        'messageoutboxid' => $faker->randomDigitNotNull,
        'mobilenumber' => $faker->word,
        'messagelanguage' => $faker->word,
        'message' => $faker->word,
        'contents' => $faker->text,
        'messagestatus' => $faker->word,
        'datetimeadded' => $faker->date('Y-m-d H:i:s'),
        'addedby' => $faker->randomDigitNotNull,
        'ipaddress' => $faker->word,
        'source' => $faker->word,
        'record_version' => $faker->randomDigitNotNull,
        'created_at' => $faker->word,
        'updated_at' => $faker->word,
        'deleted_at' => $faker->word
    ];
});
