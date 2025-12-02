<?php

namespace App\Http\Controllers;

use App\Models\CharadesThemes;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class CharadesThemesController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $themes = CharadesThemes::with('themes_to_teacher')->get();
        return response()->json([
            'success' => true,
            'message' => 'Charades themes retrieved successfully.',
            'data' => $themes,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'teacher_id' => 'required|exists:teachers,teacher_id|integer',
            'name' => 'required|string|max:255',
        ]);

        $theme = CharadesThemes::create($validated);
        return response()->json([
            "message" => "Tema charades telah dibuat", 
            "data" => $theme
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(CharadesThemes $charadesTheme): JsonResponse
    {
        $charadesTheme->load('themes_to_teacher');
        return response()->json([
            'success' => true,
            'message' => 'Charades theme retrieved successfully.',
            'data' => $charadesTheme
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, CharadesThemes $charadesTheme): JsonResponse
    {
        $validated = $request->validate([
            'teacher_id' => 'sometimes|exists:teachers,teacher_id|integer',
            'name' => 'sometimes|string|max:255',
        ]);

        $charadesTheme->update($validated);
        return response()->json([
            "message" => "Tema charades telah diperbarui", 
            "data" => $charadesTheme
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(CharadesThemes $charadesTheme): JsonResponse
    {
        $charadesTheme->delete();
        return response()->json(null, 204);
    }
}