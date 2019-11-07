<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Options;
use Faker\Generator as Faker;

$factory->define(Options::class, function (Faker $faker) {

    return [
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s')
    ];
});
