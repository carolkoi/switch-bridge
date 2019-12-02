<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateWorkflowStagesTable extends Migration
{
    /**
     * Schema table name to migrate
     * @var string
     */
    public $tableName = 'workflow_stages';

    /**
     * Run the migrations.
     * @table workflow_stages
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->tableName, function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->unsignedInteger('workflow_stage_type_id');
            $table->unsignedInteger('workflow_type_id');
            $table->integer('weight')->nullable()->default(null);

            $table->index(["workflow_type_id"], 'fk_transaction_approval_required_stages_transaction_approva_idx');

            $table->index(["workflow_stage_type_id"], 'fk_transaction_approval_required_stages_transaction_approva_idx1');
            $table->softDeletes();
            $table->nullableTimestamps();


            $table->foreign('workflow_stage_type_id', 'fk_transaction_approval_required_stages_transaction_approva_idx1')
                ->references('id')->on('workflow_stage_type')
                ->onDelete('cascade')
                ->onUpdate('no action');

            $table->foreign('workflow_type_id', 'fk_transaction_approval_required_stages_transaction_approva_idx')
                ->references('id')->on('workflow_types')
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
