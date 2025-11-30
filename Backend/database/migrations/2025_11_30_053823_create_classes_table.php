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
        Schema::create('classes', function (Blueprint $table) {
            $table->integer('classes_id')->primary();
            $table->foreignId("teacher_id")->constrained(
                table: 'teachers',
                column: 'teacher_id'
            );
            $table->string('class_name');
            $table->timestamps("created_at");

        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('classes');
    }
};
