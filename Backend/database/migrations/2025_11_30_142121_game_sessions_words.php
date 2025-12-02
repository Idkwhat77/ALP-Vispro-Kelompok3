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
            $table->id('id_game_sessions_words');
            $table->foreignId('id_game_session')->constrained('game_sessions', 'id_game_sessions');
            $table->foreignId('charades_words_id')->constrained('charades_words', 'id_charades_words');
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