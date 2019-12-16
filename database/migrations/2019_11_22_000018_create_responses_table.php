<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateResponsesTable extends Migration
{
    /**
     * Schema table name to migrate
     * @var string
     */
    public $tableName = 'responses';

    /**
     * Run the migrations.
     * @table responses
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->tableName, function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->unsignedInteger('user_id')->nullable()->default(null);
            $table->unsignedInteger('client_id')->nullable()->default(null);
            $table->unsignedInteger('template_id');
            $table->unsignedInteger('question_id');
            $table->integer('answer_type');
            $table->string('answer')->nullable()->default(null);
            $table->text('survey_uuid');
            $table->decimal('total', 10, 0)->nullable()->default(null);

            $table->index(["user_id"], 'fk_responses_users1_idx');

            $table->index(["client_id"], 'fk_responses_clients1_idx');
            $table->softDeletes();
            $table->nullableTimestamps();


            $table->foreign('client_id', 'fk_responses_clients1_idx')
                ->references('id')->on('clients')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('user_id', 'fk_responses_users1_idx')
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
