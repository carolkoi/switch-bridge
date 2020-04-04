<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Models\Setting;
use Faker\Generator as Faker;

$factory->define(Setting::class, function (Faker $faker) {

    return [
        'date_time_added' => $faker->randomDigitNotNull,
        'added_by' => $faker->randomDigitNotNull,
        'date_time_modified' => $faker->randomDigitNotNull,
        'modified_by' => $faker->randomDigitNotNull,
        'source_ip' => $faker->word,
        'latest_ip' => $faker->word,
        'setting_profile' => $faker->word,
        'setting_name' => $faker->word,
        'setting_value' => $faker->word,
        'setting_type' => $faker->word,
        'setting_status' => $faker->word,
        'record_version' => $faker->randomDigitNotNull,
        'deleted_at' => $faker->word
    ];
});
