<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Answer;
use Faker\Generator as Faker;

$factory->define(Answer::class, function (Faker $faker) {

    return [
        'question_id' => $faker->randomDigitNotNull,
        'choice' => $faker->word,
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s'),
        'deleted_at' => $faker->date('Y-m-d H:i:s')
    ];
});
