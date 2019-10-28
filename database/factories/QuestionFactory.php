<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Question;
use Faker\Generator as Faker;

$factory->define(Question::class, function (Faker $faker) {

    return [
        'template_id' => $faker->randomDigitNotNull,
        'question' => $faker->word,
        'type' => $faker->randomDigitNotNull,
        'answer_id' => $faker->randomDigitNotNull,
        'status' => $faker->word,
        'description' => $faker->text,
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s'),
        'deleted_at' => $faker->date('Y-m-d H:i:s')
    ];
});
