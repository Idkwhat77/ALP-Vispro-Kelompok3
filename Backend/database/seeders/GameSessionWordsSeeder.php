<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\GameSessionWords;
use App\Models\GameSession;
use App\Models\CharadesWords;

class GameSessionWordsSeeder extends Seeder
{
    public function run(): void
    {
        $sessions = GameSession::all();
        $words = CharadesWords::all();
        if ($sessions->count() === 0 || $words->count() === 0) return;

        $i = 0;
        // create 5 associations
        for ($k = 0; $k < 5; $k++) {
            GameSessionWords::create([
                'game_session_id' => $sessions[$k % $sessions->count()]->id_game_sessions,
                'charades_words_id' => $words[$k % $words->count()]->id_charades_words,
            ]);
        }
    }
}
