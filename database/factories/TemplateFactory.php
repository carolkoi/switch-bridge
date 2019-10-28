<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Template;
use Faker\Generator as Faker;

$factory->define(Template::class, function (Faker $faker) {

    return [
        'type' => $faker->word,
        'name' => $faker->word,
        'description' => $faker->word,
        'status' => $faker->word,
        'valid_from' => $faker->word,
        'valid_until' => $faker->word,
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s'),
        'email_msg' => $faker->text,
        'deleted_at' => $faker->date('Y-m-d H:i:s')
    ];
});
