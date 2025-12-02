<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\History;
use App\Models\GameSession;
use App\Models\Wheel;

class HistorySeeder extends Seeder
{
    public function run(): void
    {
        $sessions = GameSession::all();
        $wheels = Wheel::all();
        if ($sessions->count() === 0 || $wheels->count() === 0) return;

        for ($i = 0; $i < 5; $i++) {
            History::create([
                'game_session_id' => $sessions[$i % $sessions->count()]->id_game_sessions,
                'wheel_id' => $wheels[$i % $wheels->count()]->id_wheel,
            ]);
        }
    }
}
