<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Paybill;
use Faker\Generator as Faker;

$factory->define(Paybill::class, function (Faker $faker) {

    return [
        'date_time_added' => $faker->randomDigitNotNull,
        'added_by' => $faker->randomDigitNotNull,
        'date_time_modified' => $faker->randomDigitNotNull,
        'modified_by' => $faker->randomDigitNotNull,
        'source_ip' => $faker->word,
        'latest_ip' => $faker->word,
        'setting_profile' => $faker->word,
        'paybill_type' => $faker->word,
        'api_application_name' => $faker->word,
        'api_consumer_key' => $faker->word,
        'api_consumer_secret' => $faker->word,
        'api_consumer_code' => $faker->word,
        'api_endpoint' => $faker->word,
        'api_host' => $faker->word,
        'shortcode' => $faker->word,
        'partnercode' => $faker->word,
        'paybill_status' => $faker->word,
        'record_version' => $faker->randomDigitNotNull
    ];
});
