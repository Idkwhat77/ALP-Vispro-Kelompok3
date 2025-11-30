<?php

namespace App\Http\Controllers;

use App\Models\wheel;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule; 

class wheelController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(wheel::all());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'id_wheel' => 'required|integer|unique:wheels',
            'classes_id' => 'required|exists:classes,classes_id|integer',
            'result' => 'required|string|max:255',
        ]);
        $wheel = wheel::create($validated);
        return response()->json(["message" => "Data telah ditambahkan", "data" => $wheel], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(wheel $wheel)
    {
        return response()->json($wheel);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, wheel $wheel)
    {

    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        return response()->json( null, 204);
    }
}
