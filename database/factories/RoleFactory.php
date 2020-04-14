<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Role;
use Faker\Generator as Faker;

$factory->define(Role::class, function (Faker $faker) {

    return [
        'rolename' => $faker->word,
        'description' => $faker->word,
        'roletype' => $faker->word,
        'rolestatus' => $faker->word,
        'addedby' => $faker->randomDigitNotNull,
        'ipaddress' => $faker->word,
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s'),
        'deleted_at' => $faker->word
    ];
});
