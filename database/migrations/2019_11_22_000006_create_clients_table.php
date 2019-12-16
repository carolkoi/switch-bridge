<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateClientsTable extends Migration
{
    /**
     * Schema table name to migrate
     * @var string
     */
    public $tableName = 'clients';

    /**
     * Run the migrations.
     * @table clients
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->tableName, function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->integer('contact_id')->nullable()->default(null);
            $table->string('first_name', 45)->nullable()->default(null);
            $table->string('last_name', 45)->nullable()->default(null);
            $table->string('name', 100)->nullable()->default(null);
            $table->string('initials', 45)->nullable()->default(null);
            $table->string('email');
            $table->string('company_account', 45)->nullable()->default(null);
            $table->string('company_id', 45)->nullable()->default(null);
            $table->string('company_name', 45)->nullable()->default(null);
            $table->softDeletes();
            $table->nullableTimestamps();
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
