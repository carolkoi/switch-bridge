<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTemplatesTable extends Migration
{
    /**
     * Schema table name to migrate
     * @var string
     */
    public $tableName = 'templates';

    /**
     * Run the migrations.
     * @table templates
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->tableName, function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->unsignedInteger('user_id');
            $table->unsignedInteger('survey_type_id');
            $table->string('name');
            $table->text('email_msg')->nullable()->default(null);
            $table->string('description');
            $table->tinyInteger('approved')->default('0');
            $table->date('valid_from')->nullable()->default(null);
            $table->date('valid_until')->nullable()->default(null);

            $table->index(["survey_type_id"], 'fk_templates_survey_type_idx');

            $table->index(["user_id"], 'fk_templates_users1_idx');
            $table->softDeletes();
            $table->nullableTimestamps();


            $table->foreign('survey_type_id', 'fk_templates_survey_type_idx')
                ->references('id')->on('survey_type')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('user_id', 'fk_templates_users1_idx')
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
