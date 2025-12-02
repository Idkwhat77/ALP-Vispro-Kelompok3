<?php

namespace App\Http\Controllers;

use App\Models\History;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class HistoryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $history = History::with(['gameSession', 'wheel'])->get();
        return response()->json([
            'success' => true,
            'data' => $history,
            'message' => 'History retrieved successfully.'
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'game_session_id' => 'required|exists:game_sessions,id_game_sessions|integer',
            'wheel_id' => 'required|exists:wheels,id_wheel|integer',
        ]);

        $history = History::create($validated);
        return response()->json([
            "message" => "Riwayat telah dibuat", 
            "data" => $history
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(History $history): JsonResponse
    {
        $history->load(['gameSession', 'wheel']);
        return response()->json([
            'success' => true,
            'data' => $history,
            'message' => 'History retrieved successfully.'
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, History $history): JsonResponse
    {
        $validated = $request->validate([
            'game_session_id' => 'sometimes|exists:game_sessions,id_game_sessions|integer',
            'wheel_id' => 'sometimes|exists:wheels,id_wheel|integer',
        ]);

        $history->update($validated);
        return response()->json([
            "message" => "Riwayat telah diperbarui", 
            "data" => $history
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(History $history): JsonResponse
    {
        $history->delete();
        return response()->json(null, 204);
    }
}