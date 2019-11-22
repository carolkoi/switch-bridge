<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateAllocationsTable extends Migration
{
    /**
     * Schema table name to migrate
     * @var string
     */
    public $tableName = 'allocations';

    /**
     * Run the migrations.
     * @table allocations
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->tableName, function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->string('user_type')->nullable()->default(null);
            $table->unsignedInteger('client_id')->nullable();
            $table->unsignedInteger('user_id')->nullable()->default(null);
            $table->string('type', 45)->nullable()->default(null);
            $table->tinyInteger('status')->nullable()->default('0');
            $table->unsignedInteger('template_id');
            $table->text('others')->nullable()->default(null);
            $table->tinyInteger('email_sent')->nullable()->default('0');

            $table->index(["user_id"], 'fk_allocations_users1_idx');
            $table->softDeletes();
            $table->nullableTimestamps();


            $table->foreign('user_id', 'fk_allocations_users1_idx')
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
