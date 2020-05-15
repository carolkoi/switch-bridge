<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\SessionTxn;
use Faker\Generator as Faker;

$factory->define(SessionTxn::class, function (Faker $faker) {

    return [
        'txn_id' => $faker->word,
        'orig_txn_no' => $faker->word,
        'appended_txn_no' => $faker->word,
        'txn_status' => $faker->word,
        'comments' => $faker->word,
        'created_at' => $faker->date('Y-m-d H:i:s'),
        'updated_at' => $faker->date('Y-m-d H:i:s'),
        'deleted_at' => $faker->date('Y-m-d H:i:s')
    ];
});
