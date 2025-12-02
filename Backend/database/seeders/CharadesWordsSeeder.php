<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\CharadesWords;
use App\Models\CharadesThemes;

class CharadesWordsSeeder extends Seeder
{
    public function run(): void
    {
        $themes = CharadesThemes::all();
        if ($themes->count() === 0) return;

        // attach all words to a single theme (the first one)
        $themeId = $themes->first()->id_charades_themes;

        $words = [
            'Elephant', 'Rat', 'Dog', 'Cat', 'Giraffe'
        ];

        foreach ($words as $w) {
            CharadesWords::create([
                'charades_themes_id' => $themeId,
                'word' => $w,
            ]);
        }
    }
}
