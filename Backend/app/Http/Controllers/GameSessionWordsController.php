<?php

namespace App\Http\Controllers;

use App\Models\GameSessionWords;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class GameSessionWordsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $sessionWords = GameSessionWords::with(['gameSession', 'charadesWord'])->get();
        return response()->json([
            'success' => true,
            'data' => $sessionWords,
            'message' => 'Game session words retrieved successfully.'
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'game_session_id' => 'required|exists:game_sessions,id_game_sessions|integer',
            'charades_words_id' => 'required|exists:charades_words,id_charades_words|integer',
        ]);

        $sessionWord = GameSessionWords::create($validated);
        return response()->json([
            "message" => "Kata sesi permainan telah dibuat", 
            "data" => $sessionWord
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(GameSessionWords $gameSessionWord): JsonResponse
    {
        $gameSessionWord->load(['gameSession', 'charadesWord']);
        return response()->json([
            'success' => true,
            'data' => $gameSessionWord,
            'message' => 'Game session word retrieved successfully.'
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, GameSessionWords $gameSessionWord): JsonResponse
    {
        $validated = $request->validate([
            'game_session_id' => 'sometimes|exists:game_sessions,id_game_sessions|integer',
            'charades_words_id' => 'sometimes|exists:charades_words,id_charades_words|integer',
        ]);

        $gameSessionWord->update($validated);
        return response()->json([
            "message" => "Kata sesi permainan telah diperbarui", 
            "data" => $gameSessionWord
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(GameSessionWords $gameSessionWord): JsonResponse
    {
        $gameSessionWord->delete();
        return response()->json(null, 204);
    }
}