<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class WorkflowStagesTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {
        

        DB::table('workflow_stages')->delete();
        
        DB::table('workflow_stages')->insert(array (
            0 => 
            array (
                'id' => 1,
                'workflow_stage_type_id' => 1,
                'workflow_type_id' => 1,
                'weight' => 1,
                'deleted_at' => NULL,
                'created_at' => '2019-11-25 15:58:14',
                'updated_at' => '2019-11-25 15:58:14',
            ),
            1 => 
            array (
                'id' => 2,
                'workflow_stage_type_id' => 2,
                'workflow_type_id' => 1,
                'weight' => 2,
                'deleted_at' => NULL,
                'created_at' => '2019-11-25 15:58:30',
                'updated_at' => '2019-11-25 15:58:30',
            ),
            2 => 
            array (
                'id' => 3,
                'workflow_stage_type_id' => 3,
                'workflow_type_id' => 1,
                'weight' => 3,
                'deleted_at' => NULL,
                'created_at' => '2019-11-25 15:58:42',
                'updated_at' => '2019-11-25 15:58:42',
            ),
            3 => 
            array (
                'id' => 4,
                'workflow_stage_type_id' => 4,
                'workflow_type_id' => 1,
                'weight' => 4,
                'deleted_at' => NULL,
                'created_at' => '2019-11-26 20:17:30',
                'updated_at' => '2019-11-26 20:17:30',
            ),
        ));
        
        
    }
}