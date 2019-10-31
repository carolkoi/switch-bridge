<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Response;
use Faker\Generator as Faker;

$factory->define(Response::class, function (Faker $faker) {

    return [
        'user_id' => $faker->randomDigitNotNull,
        'client_id' => $faker->randomDigitNotNull,
        'template_id' => $faker->randomDigitNotNull,
        'question_id' => $faker->randomDigitNotNull,
        'answer_type' => $faker->randomDigitNotNull,
        'answer' => $faker->word,
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s'),
        'deleted_at' => $faker->date('Y-m-d H:i:s')
    ];
});
