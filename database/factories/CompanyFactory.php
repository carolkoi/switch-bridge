<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Company;
use Faker\Generator as Faker;

$factory->define(Company::class, function (Faker $faker) {

    return [
        'companyname' => $faker->word,
        'companyaddress' => $faker->word,
        'companyemail' => $faker->word,
        'contactperson' => $faker->word,
        'companytype' => $faker->word,
        'addedby' => $faker->randomDigitNotNull,
        'ipaddress' => $faker->word,
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s'),
        'deleted_at' => $faker->word
    ];
});
