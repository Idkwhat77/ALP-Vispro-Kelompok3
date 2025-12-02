<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // run our table seeders in dependency-safe order
        $this->call([
            TeachersSeeder::class,
            ClassesSeeder::class,
            StudentsSeeder::class,
            WheelsSeeder::class,
            CharadesThemesSeeder::class,
            CharadesWordsSeeder::class,
            GameSessionsSeeder::class,
            GameSessionWordsSeeder::class,
            HistorySeeder::class,
            PersonalAccessTokensSeeder::class,
        ]);
    }
}
