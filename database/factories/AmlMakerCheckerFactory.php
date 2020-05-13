<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\AmlMakerChecker;
use Faker\Generator as Faker;

$factory->define(AmlMakerChecker::class, function (Faker $faker) {

    return [
        'date_time_added' => $faker->randomDigitNotNull,
        'added_by' => $faker->randomDigitNotNull,
        'date_time_modified' => $faker->randomDigitNotNull,
        'modified_by' => $faker->randomDigitNotNull,
        'source_ip' => $faker->word,
        'latest_ip' => $faker->word,
        'partner_id' => $faker->word,
        'customer_idnumber' => $faker->word,
        'transaction_number' => $faker->word,
        'customer_name' => $faker->word,
        'mobile_number' => $faker->word,
        'blacklist_status' => $faker->word,
        'response' => $faker->text,
        'blacklist_source' => $faker->word,
        'remarks' => $faker->word,
        'blacklisted' => $faker->word,
        'blacklist_version' => $faker->randomDigitNotNull,
        'created_at' => $faker->word
    ];
});
