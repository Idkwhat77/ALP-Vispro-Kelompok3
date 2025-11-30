<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\teacherController;
use App\Http\Controllers\classesController;
use App\Http\Controllers\wheelController;
use App\Http\Controllers\studentController;


Route::apiResource('teachers', teacherController::class);
Route::apiResource('classes', classesController::class);
Route::apiResource('wheels', wheelController::class);
Route::apiResource('students', studentController::class);

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');
