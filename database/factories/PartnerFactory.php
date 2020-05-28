<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Partner;
use Faker\Generator as Faker;

$factory->define(Partner::class, function (Faker $faker) {

    return [
        'date_time_added' => $faker->randomDigitNotNull,
        'added_by' => $faker->randomDigitNotNull,
        'date_time_modified' => $faker->randomDigitNotNull,
        'modified_by' => $faker->randomDigitNotNull,
        'partner_idx' => $faker->randomDigitNotNull,
        'setting_profile' => $faker->word,
        'partner_name' => $faker->word,
        'partner_type' => $faker->word,
        'partner_username' => $faker->word,
        'partner_password' => $faker->word,
        'partner_api_endpoint' => $faker->word,
        'allowed_transaction_types' => $faker->word,
        'unlock_time' => $faker->randomDigitNotNull,
        'lock_status' => $faker->word,
        'partner_status' => $faker->word,
        'record_version' => $faker->randomDigitNotNull,
        'updated_at' => $faker->word,
        'created_at' => $faker->word,
        'deleted_at' => $faker->word
    ];
});
