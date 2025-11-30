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
            $table->integer('id')->primary();
            $table->integer('class_id');
            $table->integer('teacher_id');
            $table->integer('charades_theme_id');
            $table->foreign('class_id')->references('classes_id')->on('classes');
            $table->foreign('teacher_id')->references('teacher_id')->on('teachers');
            $table->foreign('charades_theme_id')->references('id')->on('charades_themes');
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