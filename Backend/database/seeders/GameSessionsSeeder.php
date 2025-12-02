<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\GameSession;
use App\Models\Classes;
use App\Models\Teacher;
use App\Models\CharadesThemes;
use Carbon\Carbon;

class GameSessionsSeeder extends Seeder
{
    public function run(): void
    {
        $classes = Classes::all();
        $teachers = Teacher::all();
        $themes = CharadesThemes::all();
        if ($classes->count() === 0 || $teachers->count() === 0 || $themes->count() === 0) return;

        for ($i = 0; $i < 5; $i++) {
            GameSession::create([
                'class_id' => $classes[$i % $classes->count()]->classes_id,
                'teacher_id' => $teachers[$i % $teachers->count()]->teacher_id,
                'charades_theme_id' => $themes[$i % $themes->count()]->id_charades_themes,
                'played_at' => Carbon::now()->subDays($i),
                'total_guess_correct' => rand(0, 10),
                'total_guess_skipped' => rand(0, 5),
            ]);
        }
    }
}
