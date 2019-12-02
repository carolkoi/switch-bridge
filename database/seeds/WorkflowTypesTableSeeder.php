<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class WorkflowTypesTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {
        

        DB::table('workflow_types')->delete();
        
        DB::table('workflow_types')->insert(array (
            0 => 
            array (
                'id' => 1,
                'name' => 'Leave Approval',
                'slug' => 'leave_approval',
                'type' => 0,
                'deleted_at' => NULL,
                'created_at' => '2019-11-25 15:25:30',
                'updated_at' => '2019-11-25 15:25:30',
            ),
        ));
        
        
    }
}