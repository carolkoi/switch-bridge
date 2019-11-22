<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateSentSurveysTable extends Migration
{
    /**
     * Schema table name to migrate
     * @var string
     */
    public $tableName = 'sent_surveys';

    /**
     * Run the migrations.
     * @table sent_surveys
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->tableName, function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('id');
            $table->unsignedInteger('template_id');
            $table->text('token')->nullable()->default(null);

            $table->index(["template_id"], 'fk_sent_surveys_templates1_idx');
            $table->softDeletes();
            $table->nullableTimestamps();


            $table->foreign('template_id', 'fk_sent_surveys_templates1_idx')
                ->references('id')->on('templates')
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
