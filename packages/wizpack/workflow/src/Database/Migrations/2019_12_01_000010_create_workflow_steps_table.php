<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateWorkflowStepsTable extends Migration
{
    /**
     * Schema table name to migrate
     * @var string
     */
    public $tableName = 'workflow_steps';

    /**
     * Run the migrations.
     * @table workflow_steps
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->tableName, function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->unsignedInteger('workflow_stage_id');
            $table->unsignedInteger('workflow_id');
            $table->unsignedInteger('user_id');
            $table->dateTime('approved_at')->nullable()->default(null);
            $table->dateTime('rejected_at')->nullable()->default(null);
            $table->integer('weight')->nullable()->default(null);

            $table->index(["workflow_stage_id"], 'fk_transaction_approval_steps_transaction_approval_stages1_idx');

            $table->index(["workflow_id"], 'fk_transaction_approval_steps_transaction_approvals1_idx');

            $table->index(["user_id"], 'fk_transaction_approval_steps_users1_idx');
            $table->softDeletes();
            $table->nullableTimestamps();


            $table->foreign('workflow_stage_id', 'fk_transaction_approval_steps_transaction_approval_stages1_idx')
                ->references('id')->on('workflow_stages')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('workflow_id', 'fk_transaction_approval_steps_transaction_approvals1_idx')
                ->references('id')->on('workflows')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('user_id', 'fk_transaction_approval_steps_users1_idx')
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
