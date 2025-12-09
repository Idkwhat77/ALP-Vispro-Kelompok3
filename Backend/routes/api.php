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

// Handle preflight OPTIONS requests
Route::options('{any}', function (Request $request) {
    return response()->json([], 200);
})->where('any', '.*');

// Authentication routes for admin panel
Route::post('/admin/login', [TeacherController::class, 'login']);
Route::post('/admin/logout', [TeacherController::class, 'logout'])->middleware('auth:sanctum');
Route::get('/admin/me', [TeacherController::class, 'me'])->middleware('auth:sanctum');

// Temporary public endpoint to test connectivity
Route::get('/test-classes', [ClassesController::class, 'getAllClasses']);

// Protected routes for admin panel (require authentication)
Route::middleware('auth:sanctum')->group(function () {
    // Custom routes first (before apiResource to avoid conflicts)
    Route::get('/classes/all', [ClassesController::class, 'getAllClasses']);
    Route::get('/classes/other', [ClassesController::class, 'getOtherClasses']);
    Route::get('/students/all', [StudentController::class, 'getAllStudents']);
    Route::get('/students/by-class/{classId}', [StudentController::class, 'getByClassId']);
    Route::get('/teachers/{teacher}/can-edit-class/{class}', [TeacherController::class, 'canEditClass']);
    Route::get('/teachers/view-all-classes', [TeacherController::class, 'viewAllClasses']);
    
    // Standard RESTful resources
    Route::apiResource('teachers', TeacherController::class);
    Route::apiResource('classes', ClassesController::class);
    Route::apiResource('students', StudentController::class);
    Route::apiResource('wheels', WheelController::class);
    Route::apiResource('charades-themes', CharadesThemesController::class);
    Route::apiResource('charades-words', CharadesWordsController::class);
    Route::apiResource('game-sessions', GameSessionController::class);
    Route::apiResource('game-session-words', GameSessionWordsController::class);
    Route::apiResource('history', HistoryController::class);
});

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

