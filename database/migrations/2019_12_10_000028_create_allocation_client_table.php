<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateAllocationClientTable extends Migration
{
    /**
     * Schema table name to migrate
     * @var string
     */
    public $tableName = 'allocation_client';

    /**
     * Run the migrations.
     * @table allocation_client
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->tableName, function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->unsignedInteger('client_id');
            $table->unsignedInteger('allocation_id');

            $table->index(["allocation_id"], 'fk_allocation_client_allocations1_idx');

            $table->index(["client_id"], 'fk_allocation_client_clients1_idx');
            $table->softDeletes();
            $table->nullableTimestamps();


            $table->foreign('allocation_id', 'fk_allocation_client_allocations1_idx')
                ->references('id')->on('allocations')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('client_id', 'fk_allocation_client_clients1_idx')
                ->references('id')->on('clients')
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
