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
        Schema::create('game_sessions', function (Blueprint $table) {
            $table->id('id_game_sessions');
            $table->foreignId('class_id')->constrained('classes', 'classes_id');
            $table->foreignId('teacher_id')->constrained('teachers', 'teacher_id');
            $table->foreignId('charades_theme_id')->constrained('charades_themes', 'id_charades_themes');
            $table->timestamp('played_at');
            $table->integer('total_guess_correct');
            $table->integer('total_guess_skipped');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('game_sessions');
    }
};