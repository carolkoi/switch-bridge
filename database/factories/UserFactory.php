<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\User;
use Faker\Generator as Faker;

$factory->define(User::class, function (Faker $faker) {

    return [
//        'name' => $faker->word,
        'first_name' =>$faker->firstName,
        'last_name' => $faker->lastName,
        'email' => $faker->email,
//        'email_verified_at' => $faker->date('Y-m-d H:i:s'),
        'password' => 'password',
        'remember_token' => bcrypt('password'),
        'deleted_at' => $faker->date('Y-m-d H:i:s'),
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s')
    ];
});
