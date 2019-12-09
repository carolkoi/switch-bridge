<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateWorkflowStageChecklistTable extends Migration
{
    /**
     * Schema table name to migrate
     * @var string
     */
    public $tableName = 'workflow_stage_checklist';

    /**
     * Run the migrations.
     * @table workflow_stage_checklist
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->tableName, function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->string('name', 100)->nullable()->default(null);
            $table->text('text')->nullable()->default(null);
            $table->tinyInteger('status')->nullable()->default(null);
            $table->unsignedInteger('workflow_stages_id');

            $table->index(["workflow_stages_id"], 'fk_workflow_stage_checklist_workflow_stages1_idx');
            $table->softDeletes();
            $table->nullableTimestamps();


            $table->foreign('workflow_stages_id', 'fk_workflow_stage_checklist_workflow_stages1_idx')
                ->references('id')->on('workflow_stages')
                ->onDelete('no action')
                ->onUpdate('no action');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
     public function down()
     {
       Schema::dropIfExists($this->tableName);
     }
}
