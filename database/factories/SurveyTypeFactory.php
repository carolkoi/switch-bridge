<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\SurveyType;
use Faker\Generator as Faker;

$factory->define(SurveyType::class, function (Faker $faker) {

    return [
        'type' => $faker->word,
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s'),
        'deleted_at' => $faker->date('Y-m-d H:i:s')
    ];
});
