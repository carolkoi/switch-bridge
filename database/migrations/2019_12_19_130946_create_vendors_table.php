<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateVendorsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('vendors', function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->integer('dc_link');
            $table->string('account', 45)->nullable();
            $table->string('name', 100)->nullable();
            $table->string('contact_person', 100)->nullable();
            $table->string('physical1', 100)->nullable();
            $table->string('physical2', 100)->nullable();
            $table->string('physical3', 100)->nullable();
            $table->string('physical4', 100)->nullable();
            $table->string('physical5', 100)->nullable();
            $table->string('post1', 100)->nullable();
            $table->string('post2', 100)->nullable();
            $table->string('post3', 100)->nullable();
            $table->string('post4', 100)->nullable();
            $table->string('post5', 100)->nullable();
            $table->string('tax_number', 100)->nullable();
            $table->string('email');
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
        Schema::dropIfExists('vendors');
    }
}
