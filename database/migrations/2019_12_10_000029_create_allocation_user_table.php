<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateAllocationUserTable extends Migration
{
    /**
     * Schema table name to migrate
     * @var string
     */
    public $tableName = 'allocation_user';

    /**
     * Run the migrations.
     * @table allocation_user
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->tableName, function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->unsignedInteger('allocation_id');
            $table->unsignedInteger('user_id');

            $table->index(["allocation_id"], 'fk_allocation_user_allocations1_idx');

            $table->index(["user_id"], 'fk_allocation_user_users1_idx');
            $table->softDeletes();
            $table->nullableTimestamps();


            $table->foreign('allocation_id', 'fk_allocation_user_allocations1_idx')
                ->references('id')->on('allocations')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('user_id', 'fk_allocation_user_users1_idx')
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
