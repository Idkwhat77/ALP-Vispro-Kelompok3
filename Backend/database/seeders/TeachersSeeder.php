<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\Teacher;

class TeachersSeeder extends Seeder
{
    public function run(): void
    {
        $teachers = [
            ['username' => 'alice', 'email' => 'alice@example.com', 'password' => Hash::make('password')],
            ['username' => 'bob', 'email' => 'bob@example.com', 'password' => Hash::make('password')],
            ['username' => 'carol', 'email' => 'carol@example.com', 'password' => Hash::make('password')],
            ['username' => 'dave', 'email' => 'dave@example.com', 'password' => Hash::make('password')],
            ['username' => 'eve', 'email' => 'eve@example.com', 'password' => Hash::make('password')],
        ];

        foreach ($teachers as $t) {
            Teacher::create($t);
        }
    }
}
