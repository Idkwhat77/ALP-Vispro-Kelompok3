<?php

namespace App\Http\Controllers;

use App\Models\Teacher;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class TeacherController extends Controller
{
    /**
     * Serve the teacher's picture as an image response.
    */
    public function picture(Teacher $teacher)
    {
        if (!$teacher->picture) {
            // Do not display anything if no image is present
            return response('', 204);
        }

            if (!$teacher->picture) {
                return response()->json(['error' => 'No picture found.'], 404);
            }
            $mime = $teacher->picture_mime ?: 'application/octet-stream';
            return response($teacher->picture)
                ->header('Content-Type', $mime);
    }

    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $teachers = Teacher::all()->map(function ($teacher) {
            $arr = $teacher->toArray();
            unset($arr['picture'], $arr['picture_mime']);
            $arr['picture_url'] = url('api/teachers/' . $teacher->teacher_id . '/picture');
            return $arr;
        });
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
            'fullname' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:teachers',
            'password' => 'required|string|min:8',
            'specialist' => 'required|string|max:255',
            'picture' => 'nullable|file|mimes:jpg,jpeg,png,gif,webp|max:2048',
        ]);

        // Hash the password
        $validated['password'] = Hash::make($validated['password']);

        // Handle picture upload as BLOB
        if ($request->hasFile('picture')) {
            $validated['picture'] = file_get_contents($request->file('picture')->getRealPath());
        }

        $teacher = Teacher::create($validated);
        return response()->json(["message" => "Guru telah ditambahkan", "data" => $teacher], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Teacher $teacher): JsonResponse
    {
        $arr = $teacher->toArray();
        unset($arr['picture'], $arr['picture_mime']);
        $arr['picture_url'] = url('api/teachers/' . $teacher->teacher_id . '/picture');
        return response()->json([
            'success' => true,
            'data' => $arr,
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
            'fullname' => 'sometimes|string|max:255',
            'email' => 'sometimes|string|email|max:255|unique:teachers,email,' . $teacher->teacher_id . ',teacher_id',
            'password' => 'sometimes|string|min:8',
            'specialist' => 'nullable|string|max:255',
            'picture' => 'nullable|file|mimes:jpg,jpeg,png,gif,webp|max:2048',
        ]);

        // Hash password if provided
        if (isset($validated['password'])) {
            $validated['password'] = Hash::make($validated['password']);
        }

        // Handle picture upload as BLOB
        if ($request->hasFile('picture')) {
            $validated['picture'] = file_get_contents($request->file('picture')->getRealPath());
        }

        $teacher->update($validated);
        return response()->json(["message" => "Guru telah diperbarui", "data" => $teacher], 200);
    }

    /**
     * Login method for web admin panel
     */
    public function login(Request $request): JsonResponse
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        // Get teacher directly from Teacher model instead of using Auth guard
        $teacher = Teacher::where('email', $request->email)->first();
        
        if (!$teacher || !Hash::check($request->password, $teacher->password)) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }
        
        // Create token on the actual Teacher model instance
        $token = $teacher->createToken('admin-panel')->plainTextToken;
        
        // Also login for web session
        Auth::guard('web')->login($teacher);
        
        return response()->json([
            'success' => true,
            'message' => 'Login successful',
            'teacher' => [
                'teacher_id' => $teacher->teacher_id,
                'username' => $teacher->username,
                'fullname' => $teacher->fullname,
                'email' => $teacher->email,
                'specialist' => $teacher->specialist,
                'picture_url' => url('api/teachers/' . $teacher->teacher_id . '/picture'),
            ],
            'token' => $token
        ]);
    }

    /**
     * Logout method for web admin panel
     */
    public function logout(Request $request): JsonResponse
    {
        if ($request->user()) {
            $request->user()->currentAccessToken()->delete();
        }
        
        Auth::guard('web')->logout();
        
        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully'
        ]);
    }

    /**
     * Get current authenticated teacher info
     */
    public function me(Request $request): JsonResponse
    {
        $teacher = $request->user();
        
        if (!$teacher) {
            return response()->json([
                'success' => false,
                'message' => 'Not authenticated'
            ], 401);
        }
        
        return response()->json([
            'success' => true,
            'teacher' => [
                'teacher_id' => $teacher->teacher_id,
                'username' => $teacher->username,
                'fullname' => $teacher->fullname,
                'email' => $teacher->email,
                'specialist' => $teacher->specialist,
                'picture_url' => url('api/teachers/' . $teacher->teacher_id . '/picture'),
            ]
        ]);
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

    /**
     * Get all classes, including those not assigned to the teacher.
     */
    public function viewAllClasses(): JsonResponse
    {
        $classes = \App\Models\Classes::all();
        return response()->json([
            'success' => true,
            'data' => $classes,
            'message' => 'All classes retrieved successfully.'
        ]);
    }
}