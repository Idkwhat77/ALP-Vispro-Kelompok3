<?php

namespace App\Http\Controllers;

use App\Models\GameSession;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class GameSessionController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $sessions = GameSession::with(['class', 'teacher', 'charadesTheme'])->get();
        return response()->json([
            'success' => true,
            'data' => $sessions,
            'message' => 'Game sessions retrieved successfully.'
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'class_id' => 'required|exists:classes,classes_id|integer',
            'teacher_id' => 'required|exists:teachers,teacher_id|integer',
            'charades_theme_id' => 'required|exists:charades_themes,id_charades_themes|integer',
            'played_at' => 'required|date',
            'total_guess_correct' => 'required|integer|min:0',
            'total_guess_skipped' => 'required|integer|min:0',
        ]);

        $session = GameSession::create($validated);
        return response()->json([
            "message" => "Sesi permainan telah dibuat", 
            "data" => $session
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(GameSession $gameSession): JsonResponse
    {
        $gameSession->load(['class', 'teacher', 'charadesTheme']);
        return response()->json([
            'success' => true,
            'data' => $gameSession,
            'message' => 'Game session retrieved successfully.'
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, GameSession $gameSession): JsonResponse
    {
        $validated = $request->validate([
            'class_id' => 'sometimes|exists:classes,classes_id|integer',
            'teacher_id' => 'sometimes|exists:teachers,teacher_id|integer',
            'charades_theme_id' => 'sometimes|exists:charades_themes,id_charades_themes|integer',
            'played_at' => 'sometimes|date',
            'total_guess_correct' => 'sometimes|integer|min:0',
            'total_guess_skipped' => 'sometimes|integer|min:0',
        ]);

        $gameSession->update($validated);
        return response()->json([
            "message" => "Sesi permainan telah diperbarui", 
            "data" => $gameSession
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(GameSession $gameSession): JsonResponse
    {
        $gameSession->delete();
        return response()->json(null, 204);
    }
}