<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateWorkflowsTable extends Migration
{
    /**
     * Schema table name to migrate
     * @var string
     */
    public $tableName = 'workflows';

    /**
     * Run the migrations.
     * @table workflows
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->tableName, function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->unsignedInteger('user_id');
            $table->string('workflow_type');
            $table->integer('model_id')->nullable();
            $table->string('model_type', 45)->nullable();
            $table->string('collection_name', 45)->nullable();
            $table->longText('payload')->nullable()->default(null);
            $table->unsignedInteger('sent_by')->nullable()->default(null);
            $table->tinyInteger('approved')->nullable()->default('0');
            $table->timestamp('approved_at')->nullable()->default(null);
            $table->timestamp('rejected_at')->nullable()->default(null);
            $table->unsignedInteger('awaiting_stage_id');

            $table->index(["awaiting_stage_id"], 'fk_transaction_approvals_transaction_approval_stages1_idx');

            $table->index(["sent_by"], 'fk_transaction_approvals_users2_idx');

            $table->index(["workflow_type"], 'fk_transaction_approvals_transaction_approval_types1_idx');

            $table->index(["user_id"], 'fk_transaction_approvals_users1_idx');
            $table->softDeletes();
            $table->nullableTimestamps();


            $table->foreign('awaiting_stage_id', 'fk_transaction_approvals_transaction_approval_stages1_idx')
                ->references('id')->on('workflow_stages')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('workflow_type', 'fk_transaction_approvals_transaction_approval_types1_idx')
                ->references('slug')->on('workflow_types')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('user_id', 'fk_transaction_approvals_users1_idx')
                ->references('id')->on('users')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('sent_by', 'fk_transaction_approvals_users2_idx')
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
