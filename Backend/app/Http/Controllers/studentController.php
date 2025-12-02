<?php

namespace App\Http\Controllers;

use App\Models\Student;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class StudentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $students = Student::with('student_to_classes')->get();
        return response()->json([
            'success' => true,
            'data' => $students,
            'message' => 'Students retrieved successfully.'
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'classes_id' => 'required|exists:classes,classes_id|integer',
            'student_name' => 'required|string|max:255',
        ]);
        
        $student = Student::create($validated);
        return response()->json(["message" => "Siswa telah ditambahkan", "data" => $student], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Student $student): JsonResponse
    {
        $student->load('student_to_classes');
        return response()->json([
            'success' => true,
            'data' => $student,
            'message' => 'Student retrieved successfully.'
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Student $student): JsonResponse
    {
        $validated = $request->validate([
            'classes_id' => 'sometimes|exists:classes,classes_id|integer',
            'student_name' => 'sometimes|string|max:255',
        ]);

        $student->update($validated);
        return response()->json(["message" => "Siswa telah diperbarui", "data" => $student], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Student $student): JsonResponse
    {
        $student->delete();
        return response()->json(null, 204);
    }
}