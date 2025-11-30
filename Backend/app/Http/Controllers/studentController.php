<?php

namespace App\Http\Controllers;

use App\Models\student;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule; 

class studentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(student::all());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'id_students' => 'required|integer|unique:students',
            'classes_id' => 'required|exists:classes,classes_id|integer',
            'student_name' => 'required|string|max:255',
        ]);
        $student = student::create($validated);
        return response()->json(["message" => "Siswa telah ditambahkan", "data" => $student], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(student $student)
    {
        return response()->json($student);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, student $student)
    {
        $validated = $request->validate([
            'id_students' => 'sometimes|integer|unique:students',
            'classes_id' => 'sometimes|exists:classes, classes_id|integer',
            'student_name' => 'sometimes|string|max:255',
        ]);

        $student->update($validated);
        return response()->json(["message" => "Siswa telah diperbarui", "data" => $student], 201);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(student $student)
    {
        $student->delete();
        return response()->json( null, 204);
    }
}
