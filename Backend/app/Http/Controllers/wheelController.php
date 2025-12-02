<?php

namespace App\Http\Controllers;

use App\Models\Wheel;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class WheelController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $wheels = Wheel::with('class')->get();
        return response()->json([
            'success' => true,
            'data' => $wheels,
            'message' => 'Wheels retrieved successfully.'
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'classes_id' => 'required|exists:classes,classes_id|integer',
            'result' => 'required|string|max:255',
        ]);
        
        $wheel = Wheel::create($validated);
        return response()->json(["message" => "Data telah ditambahkan", "data" => $wheel], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Wheel $wheel): JsonResponse
    {
        $wheel->load('class');
        return response()->json([
            'success' => true,
            'data' => $wheel,
            'message' => 'Wheel retrieved successfully.'
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Wheel $wheel): JsonResponse
    {
        $validated = $request->validate([
            'classes_id' => 'sometimes|exists:classes,classes_id|integer',
            'result' => 'sometimes|string|max:255',
        ]);

        $wheel->update($validated);
        return response()->json(["message" => "Wheel telah diperbarui", "data" => $wheel], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Wheel $wheel): JsonResponse
    {
        $wheel->delete();
        return response()->json(null, 204);
    }
}