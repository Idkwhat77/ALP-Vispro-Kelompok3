<?php

namespace App\Http\Controllers;

use App\Models\Classes;
use App\Http\Controllers\Controller;
use Illuminate\Container\Attributes\Log;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\Rule; 

class ClassesController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        
        if ($user) {
            // If authenticated, show teacher's own classes first, then others (view-only)
            $ownClasses = Classes::where('teacher_id', $user->teacher_id)->get();
            $otherClasses = Classes::where('teacher_id', '!=', $user->teacher_id)->get();
            
            return response()->json([
                'success' => true,
                'data' => [
                    'own_classes' => $ownClasses,
                    'other_classes' => $otherClasses
                ],
                'message' => 'Classes retrieved successfully.'
            ]);
        }
        
        // If not authenticated, show all (for API usage)
        $classes = Classes::all();
        return response()->json([
            'success' => true,
            'data' => $classes,
            'message' => 'Classes retrieved successfully.'
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'class_name' => 'required|string|max:255',
            'teacher_id' => 'sometimes|exists:teachers,teacher_id'
        ]);
        
        $user = $request->user();
        
        // If authenticated, use the authenticated teacher's ID
        if ($user) {
            $teacherId = $user->teacher_id;
        } else {
            // If not authenticated, require teacher_id in request (for API usage)
            $teacherId = $request->teacher_id;
            if (!$teacherId) {
                return response()->json([
                    'success' => false,
                    'message' => 'teacher_id is required when not authenticated'
                ], 400);
            }
        }
        
        $class = Classes::create([
            'teacher_id' => $teacherId,
            'class_name' => $request->class_name
        ]);
        
        return response()->json([
            'success' => true,
            'data' => $class,
            'message' => 'Class created successfully'
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Classes $class): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => $class,
            'message' => 'Class retrieved successfully.'
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Classes $class): JsonResponse
    {
        $user = $request->user();
        
        // Check if teacher owns this class
        if ($user && $class->teacher_id !== $user->teacher_id) {
            return response()->json([
                'success' => false,
                'message' => 'You can only edit your own classes'
            ], 403);
        }
        
        $request->validate([
            'class_name' => 'sometimes|string|max:255'
        ]);
        
        $class->update($request->only(['class_name']));
        
        return response()->json([
            'success' => true,
            'data' => $class,
            'message' => 'Class updated successfully'
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request, Classes $class): JsonResponse
    {
        $user = $request->user();
        
        // Check if teacher owns this class
        if ($user && $class->teacher_id !== $user->teacher_id) {
            return response()->json([
                'success' => false,
                'message' => 'You can only delete your own classes'
            ], 403);
        }
        
        try {
            // Delete related students first
            $class->students()->delete();
            
            // Delete related wheels and their history records
            foreach ($class->wheels as $wheel) {
                $wheel->histories()->delete();
                $wheel->delete();
            }
            
            // Delete related game sessions and their dependent records
            foreach ($class->gameSessions as $gameSession) {
                $gameSession->gameSessionWords()->delete();
                $gameSession->histories()->delete();
                $gameSession->delete();
            }
            
            // Now delete the class
            $class->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Class deleted successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false, 
                'message' => 'Failed to delete class due to related records',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
