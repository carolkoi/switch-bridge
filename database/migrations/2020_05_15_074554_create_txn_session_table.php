<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTxnSessionTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('txn_session', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->bigInteger('txn_id');
            $table->string('orig_txn_no');
            $table->string('appended_txn_no');
            $table->string('txn_status');
            $table->string('comments');
            $table->string('sync_message');
            $table->timestamps();
            $table->timestamp('deleted_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('txn_session');
    }
}
