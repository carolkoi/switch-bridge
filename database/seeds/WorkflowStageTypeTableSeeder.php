<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class WorkflowStageTypeTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {
        

        DB::table('workflow_stage_type')->delete();
        
        DB::table('workflow_stage_type')->insert(array (
            0 => 
            array (
                'id' => 1,
                'name' => 'Supervisor/Manager Approval',
                'slug' => 'first_approver',
                'weight' => 1,
                'deleted_at' => NULL,
                'created_at' => '2019-11-25 15:49:19',
                'updated_at' => '2019-11-27 10:53:01',
            ),
            1 => 
            array (
                'id' => 2,
                'name' => 'Finance approval',
                'slug' => 'second_approver',
                'weight' => 2,
                'deleted_at' => NULL,
                'created_at' => '2019-11-25 15:49:34',
                'updated_at' => '2019-11-27 10:53:20',
            ),
            2 => 
            array (
                'id' => 3,
                'name' => 'HR approval',
                'slug' => 'third_approver',
                'weight' => 3,
                'deleted_at' => NULL,
                'created_at' => '2019-11-25 15:49:49',
                'updated_at' => '2019-11-27 10:50:53',
            ),
            3 => 
            array (
                'id' => 4,
                'name' => 'Director Approval',
                'slug' => 'fourth_approver',
                'weight' => 4,
                'deleted_at' => NULL,
                'created_at' => '2019-11-25 15:50:31',
                'updated_at' => '2019-11-27 10:51:41',
            ),
        ));
        
        
    }
}