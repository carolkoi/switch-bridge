<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Product;
use Faker\Generator as Faker;

$factory->define(Product::class, function (Faker $faker) {

    return [
        'serviceproviderid' => $faker->randomDigitNotNull,
        'product' => $faker->word,
        'productcode' => $faker->word,
        'description' => $faker->word,
        'charges' => $faker->word,
        'commission' => $faker->word,
        'transactiontype' => $faker->word,
        'status' => $faker->word,
        'addedby' => $faker->randomDigitNotNull,
        'modifiedby' => $faker->randomDigitNotNull,
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s'),
        'deleted_at' => $faker->word
    ];
});
