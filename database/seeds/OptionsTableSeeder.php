<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class OptionsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('options')->delete();

        DB::table('options')->insert(array (
            0 =>
                array (
                    'id' => 1,
                    'option_name' => 'automatic_survey_send',
                    'questions' => 'Allow automatic sending of surveys',
                    'value' => 0,
                    'deleted_at' => NULL,
                    'created_at' => '2019-11-25 16:18:16',
                    'updated_at' => '2019-11-25 16:18:16',
                ),
            1 =>
                array (
                    'id' => 2,
                    'option_name' => 'receive_late_response',
                    'questions' => 'Receive responses after valid end date',
                    'value' => 0,
                    'deleted_at' => NULL,
                    'created_at' => '2019-11-25 16:18:16',
                    'updated_at' => '2019-11-25 16:18:16',
                ),
            2 =>
                array (
                    'id' => 3,
                    'option_name' => 'anonymous_responses',
                    'questions' => 'Receive responses anonymously',
                    'value' => 0,
                    'deleted_at' => NULL,
                    'created_at' => '2019-11-25 16:18:16',
                    'updated_at' => '2019-11-25 16:18:16',
                ),
        ));


    }
}
