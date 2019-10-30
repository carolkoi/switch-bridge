<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Allocation;
use Faker\Generator as Faker;

$factory->define(Allocation::class, function (Faker $faker) {

    return [
        'user_type' => $faker->word,
        'client_id' => $faker->randomDigitNotNull,
        'user_id' => $faker->randomDigitNotNull,
        'type' => $faker->word,
        'template_id' => $faker->randomDigitNotNull,
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s'),
        'deleted_at' => $faker->date('Y-m-d H:i:s')
    ];
});
