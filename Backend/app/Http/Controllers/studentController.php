<?php

namespace App\Http\Controllers;

use App\Models\Student;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;

class StudentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        
        if ($user) {
            // If authenticated, show only students from teacher's classes
            $students = Student::with('student_to_classes')
                ->whereHas('student_to_classes', function($query) use ($user) {
                    $query->where('teacher_id', $user->teacher_id);
                })->get();
        } else {
            // If not authenticated, show all (for API usage)
            $students = Student::with('student_to_classes')->get();
        }
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
        $request->validate([
            'classes_id' => 'required|exists:classes,classes_id',
            'student_name' => 'required|string|max:255'
        ]);
        
        $user = $request->user();
        
        if ($user) {
            // Check if the class belongs to the authenticated teacher
            $class = \App\Models\Classes::find($request->classes_id);
            if ($class->teacher_id !== $user->teacher_id) {
                return response()->json([
                    'success' => false,
                    'message' => 'You can only add students to your own classes'
                ], 403);
            }
        }
        
        $student = Student::create($request->only(['classes_id', 'student_name']));
        
        return response()->json([
            'success' => true,
            'data' => $student->load('student_to_classes'),
            'message' => 'Student created successfully'
        ], 201);
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
        $user = $request->user();
        
        if ($user) {
            // Check if the student's class belongs to the authenticated teacher
            if ($student->student_to_classes->teacher_id !== $user->teacher_id) {
                return response()->json([
                    'success' => false,
                    'message' => 'You can only edit students from your own classes'
                ], 403);
            }
        }
        
        $validatedData = $request->validate([
            'classes_id' => 'sometimes|exists:classes,classes_id',
            'student_name' => 'sometimes|string|max:255',
        ]);
        
        // If updating classes_id, ensure new class also belongs to teacher
        if (isset($validatedData['classes_id']) && $user) {
            $newClass = \App\Models\Classes::find($validatedData['classes_id']);
            if ($newClass->teacher_id !== $user->teacher_id) {
                return response()->json([
                    'success' => false,
                    'message' => 'You can only move students to your own classes'
                ], 403);
            }
        }
        
        $student->update($validatedData);
        
        return response()->json([
            'success' => true,
            'data' => $student->load('student_to_classes'),
            'message' => 'Student updated successfully'
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request, Student $student): JsonResponse
    {
        $user = $request->user();
        
        if ($user) {
            // Check if the student's class belongs to the authenticated teacher
            if ($student->student_to_classes->teacher_id !== $user->teacher_id) {
                return response()->json([
                    'success' => false,
                    'message' => 'You can only delete students from your own classes'
                ], 403);
            }
        }
        
        $student->delete();
        
        return response()->json([
            'success' => true,
            'message' => 'Student deleted successfully'
        ]);
    }
}