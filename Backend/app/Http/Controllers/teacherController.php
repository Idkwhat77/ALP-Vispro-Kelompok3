<?php

namespace App\Http\Controllers;

use App\Models\teacher;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule; 

class teacherController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'teacher_id' => 'required|integer|unique:teachers',
            'username' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:teachers',
            'password' => 'required|string|min:8',
        ]);

        $teacher = teacher::create($validated);
        return response()->json(["message" => "Guru telah ditambahkan", "data" => $teacher], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(teacher $teacher)
    {
        return response()->json($teacher);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, teacher $teacher)
    {
        $validated = $request->validate([
            'teacher_id' => 'sometimes|integer|unique:teachers',
            'username' => 'sometimes|string|max:255',
        ]);

        $teacher->update($validated);
        return response()->json(["message" => "Guru telah diperbarui", "data" => $teacher], 201);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(teacher $teacher)
    {
        $teacher->delete();
        return response()->json( null, 204);
    }
}
