<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('history', function (Blueprint $table) {
            $table->integer('id')->primary();
            $table->integer('game_session_id');
            $table->integer('wheel_id');
            $table->foreign('game_session_id')->references('id')->on('game_sessions');
            $table->foreign('wheel_id')->references('id_wheel')->on('wheels');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('history');
    }
};