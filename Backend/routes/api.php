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

// Authentication routes for admin panel
Route::post('/admin/login', [TeacherController::class, 'login']);
Route::post('/admin/logout', [TeacherController::class, 'logout'])->middleware('auth:sanctum');
Route::get('/admin/me', [TeacherController::class, 'me'])->middleware('auth:sanctum');

// Protected routes for admin panel (require authentication)
Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('teachers', TeacherController::class);
    Route::apiResource('classes', ClassesController::class);
    Route::apiResource('students', StudentController::class);
    Route::apiResource('wheels', WheelController::class);
    Route::apiResource('charades-themes', CharadesThemesController::class);
    Route::apiResource('charades-words', CharadesWordsController::class);
    Route::apiResource('game-sessions', GameSessionController::class);
    Route::apiResource('game-session-words', GameSessionWordsController::class);
    Route::apiResource('history', HistoryController::class);
    Route::get('/teachers/{teacher}/can-edit-class/{class}', [TeacherController::class, 'canEditClass']);
    Route::get('/teachers/view-all-classes', [TeacherController::class, 'viewAllClasses']);
    Route::get('/classes/other', [ClassesController::class, 'getOtherClasses']);
    Route::get('/classes/all', [ClassesController::class, 'getAllClasses']);
});

// Public API routes for Flutter app (no auth required)
Route::prefix('public')->group(function () {
    Route::apiResource('teachers', TeacherController::class);
    Route::apiResource('classes', ClassesController::class);
    Route::apiResource('wheels', WheelController::class);
    Route::apiResource('students', StudentController::class);
    Route::apiResource('charades-themes', CharadesThemesController::class);
    Route::apiResource('charades-words', CharadesWordsController::class);
    Route::apiResource('game-sessions', GameSessionController::class);
    Route::apiResource('game-session-words', GameSessionWordsController::class);
    Route::apiResource('history', HistoryController::class);
    Route::get('/teachers/{teacher}/can-edit-class/{class}', [TeacherController::class, 'canEditClass']);
    Route::get('/teachers/view-all-classes', [TeacherController::class, 'viewAllClasses']);
    Route::get('/classes/other', [ClassesController::class, 'getOtherClasses']);
    Route::get('/classes/all', [ClassesController::class, 'getAllClasses']);
});

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

