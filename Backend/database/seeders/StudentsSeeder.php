<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Student;
use App\Models\Classes;

class StudentsSeeder extends Seeder
{
    public function run(): void
    {
        $classes = Classes::all();
        if ($classes->count() === 0) return;

        $studentNames = [
            'John Doe', 'Jane Smith', 'Michael Brown', 'Linda Johnson', 'Chris Lee'
        ];

        $i = 0;
        foreach ($studentNames as $name) {
            Student::create([
                'classes_id' => $classes[$i % $classes->count()]->classes_id,
                'student_name' => $name,
            ]);
            $i++;
        }
    }
}
