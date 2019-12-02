<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class WorkflowStageApproversTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {
        

        DB::table('workflow_stage_approvers')->delete();
        
        DB::table('workflow_stage_approvers')->insert(array (
            0 => 
            array (
                'id' => 1,
                'user_id' => 1,
                'granted_by' => 1,
                'workflow_stage_id' => 1,
                'workflow_stage_type_id' => 1,
                'deleted_at' => NULL,
                'created_at' => '2019-11-25 16:18:16',
                'updated_at' => '2019-11-25 16:18:16',
            ),
            1 => 
            array (
                'id' => 2,
                'user_id' => 1,
                'granted_by' => 1,
                'workflow_stage_id' => 2,
                'workflow_stage_type_id' => 2,
                'deleted_at' => NULL,
                'created_at' => '2019-11-25 16:18:29',
                'updated_at' => '2019-11-25 16:18:29',
            ),
            2 => 
            array (
                'id' => 3,
                'user_id' => 2,
                'granted_by' => 1,
                'workflow_stage_id' => 3,
                'workflow_stage_type_id' => 3,
                'deleted_at' => NULL,
                'created_at' => '2019-11-26 08:04:31',
                'updated_at' => '2019-11-26 08:04:31',
            ),
            3 => 
            array (
                'id' => 4,
                'user_id' => 2,
                'granted_by' => 1,
                'workflow_stage_id' => 1,
                'workflow_stage_type_id' => 1,
                'deleted_at' => NULL,
                'created_at' => '2019-11-26 11:54:50',
                'updated_at' => '2019-11-26 11:54:50',
            ),
            4 => 
            array (
                'id' => 5,
                'user_id' => 1,
                'granted_by' => 2,
                'workflow_stage_id' => 4,
                'workflow_stage_type_id' => 4,
                'deleted_at' => NULL,
                'created_at' => '2019-11-26 20:19:18',
                'updated_at' => '2019-11-27 05:21:28',
            ),
            5 => 
            array (
                'id' => 6,
                'user_id' => 3,
                'granted_by' => 3,
                'workflow_stage_id' => 1,
                'workflow_stage_type_id' => 1,
                'deleted_at' => NULL,
                'created_at' => '2019-11-27 07:41:25',
                'updated_at' => '2019-11-27 07:41:25',
            ),
        ));
        
        
    }
}