<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\CharadesThemes;
use App\Models\Teacher;

class CharadesThemesSeeder extends Seeder
{
    public function run(): void
    {
        $teachers = Teacher::all();
        if ($teachers->count() === 0) return;

        $names = ['Animals', 'Actions', 'Objects', 'Jobs', 'Movies'];
        $i = 0;
        foreach ($names as $name) {
            CharadesThemes::create([
                'teacher_id' => $teachers[$i % $teachers->count()]->teacher_id,
                'name' => $name,
            ]);
            $i++;
        }
    }
}
