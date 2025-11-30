<?php

namespace App\Http\Controllers;

use App\Models\classes;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule; 

class classesController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(classes::all());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'classes_id' => 'required|integer|unique:classes',
            'teacher_id' => 'required|exists:teachers,teacher_id|integer',
            'class_name' => 'required|string|max:255',
        ]);

        $classes = classes::create($validated);
        return response()->json(["message" => "Kelas telah dibuat", "data" => $classes], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(classes $classes)
    {
        return response()->json($classes);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, classes $classes)
    {
        $validated = $request->validate([
            'classes_id' => 'sometimes|integer|unique:classes',
            'teacher_id' => 'sometimes|exists:teachers,teacher_id|integer',
            'class_name' => 'sometimes|string|max:255',
        ]);

        $classes->update($validated);
        return response()->json(["message" => "Kelas telah diperbarui", "data" => $classes], 201);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(classes $classes)
    {
        $classes->delete();
        return response()->json( null, 204);
    }
}
