<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class UsersTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('users')->delete();
        DB::table('users')->insert(array(
            5 =>
                array(
                    'id' => 6,
                    'name' => 'Jose Luke',
                    'first_name' => 'Jose',
                    'last_name' => 'Luke',
                    'email' => 'joseluke@wizag.biz',
                    'role_id' => NULL,
                    'password' => bcrypt('password'),
                    'remember_token' => NULL,
                    'deleted_at' => NULL,
                    'created_at' => '2019-11-25 16:18:16',
                    'updated_at' => '2019-11-25 16:18:16',
                ),
            6 =>
            array(
                'id' => 7,
                'name' => 'Jose Luke',
                'first_name' => 'Jose',
                'last_name' => 'Luke',
                'email' => 'joseluke@wizag.biz',
                'role_id' => NULL,
                'password' => bcrypt('password'),
                'remember_token' => NULL,
                'deleted_at' => NULL,
                'created_at' => '2019-11-25 16:18:16',
                'updated_at' => '2019-11-25 16:18:16',
            ),
            7 =>
                array(
                    'id' => 8,
                    'name' => 'Jose Luke',
                    'first_name' => 'Jose',
                    'last_name' => 'Luke',
                    'email' => 'joseluke@wizag.biz',
                    'role_id' => NULL,
                    'password' => bcrypt('password'),
                    'remember_token' => NULL,
                    'deleted_at' => NULL,
                    'created_at' => '2019-11-25 16:18:16',
                    'updated_at' => '2019-11-25 16:18:16',
                ),
            8 =>
                array(
                    'id' => 9,
                    'name' => 'Jose Luke',
                    'first_name' => 'Jose',
                    'last_name' => 'Luke',
                    'email' => 'joseluke@wizag.biz',
                    'role_id' => NULL,
                    'password' => bcrypt('password'),
                    'remember_token' => NULL,
                    'deleted_at' => NULL,
                    'created_at' => '2019-11-25 16:18:16',
                    'updated_at' => '2019-11-25 16:18:16',

                )
        ));
        //
    }
}
