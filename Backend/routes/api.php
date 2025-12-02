<?php
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TeacherController;
use App\Http\Controllers\ClassesController;
use App\Http\Controllers\WheelController;
use App\Http\Controllers\StudentController;
use App\Http\Controllers\CharadesThemesController;
use App\Http\Controllers\CharadesWordsController;
use App\Http\Controllers\GameSessionController;
use App\Http\Controllers\GameSessionWordsController;
use App\Http\Controllers\HistoryController;

Route::apiResource('teachers', TeacherController::class);
Route::apiResource('classes', ClassesController::class);
Route::apiResource('wheels', WheelController::class);
Route::apiResource('students', StudentController::class);
Route::apiResource('charades-themes', CharadesThemesController::class);
Route::apiResource('charades-words', CharadesWordsController::class);
Route::apiResource('game-sessions', GameSessionController::class);
Route::apiResource('game-session-words', GameSessionWordsController::class);
Route::apiResource('history', HistoryController::class);

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');