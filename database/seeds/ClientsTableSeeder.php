<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ClientsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('clients')->delete();
        DB::table('clients')->insert(array(
            2 =>
            array(
                'id' => 3,
                'contact_id' => 14,
                'first_name' => 'Allan',
                'last_name' => 'Kirui',
                'name' => 'Allan Kirui',
                'initials' => 'AK',
                'email' => 'joseluke@wizag.biz',
                'company_account' => 'W087',
                'company_id' => 1,
                'company_name' => 'Wizag',
                'deleted_at' => NULL,
                'created_at' => '2019-11-25 16:18:16',
                'updated_at' => '2019-11-25 16:18:16',
            ),
            3 =>
                array(
                    'id' => 4,
                    'contact_id' => 15,
                    'first_name' => 'John',
                    'last_name' => 'Didinya',
                    'name' => 'John Didinya',
                    'initials' => 'JD',
                    'email' => 'johndidinya@wizag.biz',
                    'company_account' => 'W087',
                    'company_id' => 1,
                    'company_name' => 'Wizag',
                    'deleted_at' => NULL,
                    'created_at' => '2019-11-25 16:18:16',
                    'updated_at' => '2019-11-25 16:18:16',
                ),
            4 =>
                array(
                    'id' => 5,
                    'contact_id' => 15,
                    'first_name' => 'Alvin',
                    'last_name' => 'Musungu',
                    'name' => 'Alvin Musungu',
                    'initials' => 'AM',
                    'email' => 'alvinm@wizag.biz',
                    'company_account' => 'W087',
                    'company_id' => 1,
                    'company_name' => 'Wizag',
                    'deleted_at' => NULL,
                    'created_at' => '2019-11-25 16:18:16',
                    'updated_at' => '2019-11-25 16:18:16',
                ),
            5 =>
                array(
                    'id' => 6,
                    'contact_id' => 14,
                    'first_name' => 'Lucy',
                    'last_name' => 'Mbinya',
                    'name' => 'Lucy Mbinya',
                    'initials' => 'LM',
                    'email' => 'lucym@wizag.biz',
                    'company_account' => 'A001',
                    'company_id' => 2,
                    'company_name' => 'ARM Cement  Limited',
                    'deleted_at' => NULL,
                    'created_at' => '2019-11-25 16:18:16',
                    'updated_at' => '2019-11-25 16:18:16',
                ),
            6 =>
                array(
                    'id' => 7,
                    'contact_id' => 14,
                    'first_name' => 'Lily',
                    'last_name' => 'Kanaga',
                    'name' => 'Lily Kanaga',
                    'initials' => 'LK',
                    'email' => 'lilyk@wizag.biz',
                    'company_account' => 'A001',
                    'company_id' => 2,
                    'company_name' => 'ARM Cement  Limited',
                    'deleted_at' => NULL,
                    'created_at' => '2019-11-25 16:18:16',
                    'updated_at' => '2019-11-25 16:18:16',
                ),
            7 =>
                array(
                    'id' => 8,
                    'contact_id' => 14,
                    'first_name' => 'Vinnie',
                    'last_name' => 'Kituyi',
                    'name' => 'Vinnie Kituyi',
                    'initials' => 'VK',
                    'email' => 'vinniek@wizag.biz',
                    'company_account' => 'A001',
                    'company_id' => 2,
                    'company_name' => 'ARM Cement  Limited',
                    'deleted_at' => NULL,
                    'created_at' => '2019-11-25 16:18:16',
                    'updated_at' => '2019-11-25 16:18:16',
                ),

        ));
        //
    }
}
