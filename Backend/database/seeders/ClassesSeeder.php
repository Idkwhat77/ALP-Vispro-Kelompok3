<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Classes;
use App\Models\Teacher;

class ClassesSeeder extends Seeder
{
    public function run(): void
    {
        $teachers = Teacher::all();
        if ($teachers->count() === 0) return;

        $names = ['Class A', 'Class B', 'Class C', 'Class D', 'Class E'];
        $i = 0;
        foreach ($names as $name) {
            Classes::create([
                'teacher_id' => $teachers[$i % $teachers->count()]->teacher_id,
                'class_name' => $name,
            ]);
            $i++;
        }
    }
}
