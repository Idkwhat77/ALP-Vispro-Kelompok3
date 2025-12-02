<?php

namespace App\Http\Controllers;

use App\Models\CharadesWords;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class CharadesWordsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $words = CharadesWords::with('charadesTheme')->get();
        return response()->json([
            'success' => true,
            'data' => $words,
            'message' => 'Charades words retrieved successfully.'
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'charades_themes_id' => 'required|exists:charades_themes,id_charades_themes|integer',
            'word' => 'required|string|max:255',
        ]);

        $word = CharadesWords::create($validated);
        return response()->json([
            "message" => "Kata charades telah dibuat", 
            "data" => $word
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(CharadesWords $charadesWord): JsonResponse
    {
        $charadesWord->load('charadesTheme');
        return response()->json([
            'success' => true,
            'data' => $charadesWord,
            'message' => 'Charades word retrieved successfully.'
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, CharadesWords $charadesWord): JsonResponse
    {
        $validated = $request->validate([
            'charades_themes_id' => 'sometimes|exists:charades_themes,id_charades_themes|integer',
            'word' => 'sometimes|string|max:255',
        ]);

        $charadesWord->update($validated);
        return response()->json([
            "message" => "Kata charades telah diperbarui", 
            "data" => $charadesWord
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(CharadesWords $charadesWord): JsonResponse
    {
        $charadesWord->delete();
        return response()->json(null, 204);
    }
}