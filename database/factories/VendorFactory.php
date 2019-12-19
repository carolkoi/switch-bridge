<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Vendor;
use Faker\Generator as Faker;

$factory->define(Vendor::class, function (Faker $faker) {

    return [
        'account' => $faker->word,
        'name' => $faker->word,
        'contact_person' => $faker->word,
        'physical1' => $faker->word,
        'physical2' => $faker->word,
        'physical3' => $faker->word,
        'physical4' => $faker->word,
        'physical5' => $faker->word,
        'post1' => $faker->word,
        'post2' => $faker->word,
        'post3' => $faker->word,
        'post4' => $faker->word,
        'post5' => $faker->word,
        'tax_number' => $faker->word,
        'email' => $faker->word,
        'deleted_at' => $faker->date('Y-m-d H:i:s'),
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s')
    ];
});
