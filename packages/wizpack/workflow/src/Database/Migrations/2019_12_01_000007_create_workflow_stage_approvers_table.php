<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateWorkflowStageApproversTable extends Migration
{
    /**
     * Schema table name to migrate
     * @var string
     */
    public $tableName = 'workflow_stage_approvers';

    /**
     * Run the migrations.
     * @table workflow_stage_approvers
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->tableName, function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->unsignedInteger('user_id');
            $table->unsignedInteger('granted_by');
            $table->unsignedInteger('workflow_stage_id');
            $table->unsignedInteger('workflow_stage_type_id');

            $table->index(["user_id"], 'fk_transaction_approvers_users1_idx');

            $table->index(["workflow_stage_type_id"], 'fk_transaction_approvers_transaction_approval_stages1_idx');

            $table->index(["workflow_stage_id"], 'fk_transaction_approvers_transaction_approval_stages2_idx');

            $table->index(["granted_by"], 'fk_transaction_approvers_users2_idx');
            $table->softDeletes();
            $table->nullableTimestamps();


            $table->foreign('workflow_stage_type_id', 'fk_transaction_approvers_transaction_approval_stages1_idx')
                ->references('id')->on('workflow_stage_type')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('workflow_stage_id', 'fk_transaction_approvers_transaction_approval_stages2_idx')
                ->references('id')->on('workflow_stages')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('user_id', 'fk_transaction_approvers_users1_idx')
                ->references('id')->on('users')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('granted_by', 'fk_transaction_approvers_users2_idx')
                ->references('id')->on('users')
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
