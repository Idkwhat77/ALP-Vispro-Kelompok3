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
        Schema::create('charades_words', function (Blueprint $table) {
            $table->integer('id')->primary();
            $table->integer('charades_themes_id');
            $table->foreign('charades_themes_id')->references('id')->on('charades_themes');
            $table->string('word');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('charades_words');
    }
};