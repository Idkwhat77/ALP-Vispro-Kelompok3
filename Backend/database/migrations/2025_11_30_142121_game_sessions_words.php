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
        Schema::create('game_sessions_words', function (Blueprint $table) {
            $table->integer('id')->primary();
            $table->integer('game_session_id');
            $table->integer('charades_words_id');
            $table->foreign('game_session_id')->references('id')->on('game_sessions');
            $table->foreign('charades_words_id')->references('id')->on('charades_words');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('game_sessions_words');
    }
};