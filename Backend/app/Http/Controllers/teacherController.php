<?php

namespace App\Http\Controllers;

use App\Models\Teacher;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;

class TeacherController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $teachers = Teacher::all();
        return response()->json([
            'success' => true,
            'data' => $teachers,
            'message' => 'Teachers retrieved successfully.'
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'username' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:teachers',
            'password' => 'required|string|min:8',
        ]);

        // Hash the password
        $validated['password'] = Hash::make($validated['password']);

        $teacher = Teacher::create($validated);
        return response()->json(["message" => "Guru telah ditambahkan", "data" => $teacher], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Teacher $teacher): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => $teacher,
            'message' => 'Teacher retrieved successfully.'
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Teacher $teacher): JsonResponse
    {
        $validated = $request->validate([
            'username' => 'sometimes|string|max:255',
            'email' => 'sometimes|string|email|max:255|unique:teachers,email,' . $teacher->teacher_id . ',teacher_id',
            'password' => 'sometimes|string|min:8',
        ]);

        // Hash password if provided
        if (isset($validated['password'])) {
            $validated['password'] = Hash::make($validated['password']);
        }

        $teacher->update($validated);
        return response()->json(["message" => "Guru telah diperbarui", "data" => $teacher], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Teacher $teacher): JsonResponse
    {
        try {
            Log::info('Destroy method called for teacher ID: ' . $teacher->teacher_id);
            
            // Delete related game sessions and their dependent records
            foreach ($teacher->gameSessions as $gameSession) {
                // Delete game session words first
                $gameSession->gameSessionWords()->delete();
                // Delete history records for this game session
                $gameSession->histories()->delete();
                // Delete the game session
                $gameSession->delete();
            }
            
            // Delete related classes and their dependent records
            foreach ($teacher->classes as $class) {
                // Delete students in this class
                $class->students()->delete();
                // Delete wheels in this class
                $class->wheels()->delete();
                // Delete the class
                $class->delete();
            }
            
            // Delete related charades themes and their words
            foreach ($teacher->charadesThemes as $theme) {
                foreach ($theme->charadesWords as $word) {
                    // Delete GameSessionWords that reference this charades word
                    \App\Models\GameSessionWords::where('charades_words_id', $word->id_charades_words)->delete();
                    // Delete the charades word
                    $word->delete();
                }
                // Delete the theme
                $theme->delete();
            }
            
            // Now delete the teacher
            $teacher->delete();
            
            Log::info('Teacher deleted successfully: ' . $teacher->teacher_id);
            return response()->json(null, 204);
        } catch (\Exception $e) {
            Log::error('Error deleting teacher: ' . $e->getMessage());
            Log::error('Stack trace: ' . $e->getTraceAsString());
            
            $errorMessage = 'Failed to delete teacher. Error: ' . $e->getMessage() . 
                           ' | File: ' . $e->getFile() . 
                           ' | Line: ' . $e->getLine() . 
                           ' | Code: ' . $e->getCode() . 
                           ' | Teacher ID: ' . $teacher->teacher_id . 
                           ' | Teacher Username: ' . $teacher->username . 
                           ' | Error Type: ' . get_class($e) . 
                           ' | Stack Trace: ' . $e->getTraceAsString();
            
            return response()->json([
                'error' => 'Failed to delete teacher due to related records',
                'detailed_error' => $e->getMessage(),
                'error_type' => get_class($e),
                'error_code' => $e->getCode(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'teacher_id' => $teacher->teacher_id,
                'teacher_username' => $teacher->username,
                'full_trace' => $e->getTraceAsString(),
                'debug_message' => $errorMessage
            ], 500);
        }
    }
}