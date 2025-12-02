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
    public function index(): JsonResponse
    {
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
        $validated = $request->validate([
            'teacher_id' => 'required|exists:teachers,teacher_id|integer',
            'class_name' => 'required|string|max:255',
        ]);

        $classes = Classes::create($validated);
        return response()->json(["message" => "Kelas telah dibuat", "data" => $classes], 201);
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
        $validated = $request->validate([
            'teacher_id' => 'sometimes|exists:teachers,teacher_id|integer',
            'class_name' => 'sometimes|string|max:255',
        ]);

        $class->update($validated);
        return response()->json(["message" => "Kelas telah diperbarui", "data" => $class], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Classes $class): JsonResponse
    {
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
            
            return response()->json(null, 204);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to delete class due to related records'], 500);
        }
    }
}
