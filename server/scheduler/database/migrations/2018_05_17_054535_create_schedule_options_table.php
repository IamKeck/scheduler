<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateScheduleOptionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('schedule_options', function (Blueprint $table) {
            $table->increments('id');
            $table->integer("schedules_id")->unsigned();
            $table->foreign("schedules_id")->references("id")->on("schedules");
            $table->dateTime("initial_time");
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('schedule_options');
    }
}
