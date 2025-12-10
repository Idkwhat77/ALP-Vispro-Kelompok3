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
            [
                'username' => 'alice',
                'email' => 'alice@example.com',
                'password' => Hash::make('password'),
                'specialist' => 'Mathematics',
                'picture' => file_exists(__DIR__.'/alice.png') ? file_get_contents(__DIR__.'/alice.png') : null,
                'picture_mime' => 'image/png',
            ],
            [
                'username' => 'bob',
                'email' => 'bob@example.com',
                'password' => Hash::make('password'),
                'specialist' => 'Physics',
                'picture' => file_exists(__DIR__.'/bob.jpg') ? file_get_contents(__DIR__.'/bob.jpg') : null,
                'picture_mime' => 'image/jpeg',
            ],
            [
                'username' => 'carol',
                'email' => 'carol@example.com',
                'password' => Hash::make('password'),
                'specialist' => 'Chemistry',
                'picture' => file_exists(__DIR__.'/carol.jpg') ? file_get_contents(__DIR__.'/carol.jpg') : null,
                'picture_mime' => 'image/jpeg',
            ],
            [
                'username' => 'dave',
                'email' => 'dave@example.com',
                'password' => Hash::make('password'),
                'specialist' => 'Biology',
                'picture' => file_exists(__DIR__.'/dave.jpg') ? file_get_contents(__DIR__.'/dave.jpg') : null,
                'picture_mime' => 'image/jpeg',
            ],
            [
                'username' => 'eve',
                'email' => 'eve@example.com',
                'password' => Hash::make('password'),
                'specialist' => 'English',
                'picture' => file_exists(__DIR__.'/eve.jpg') ? file_get_contents(__DIR__.'/eve.jpg') : null,
                'picture_mime' => 'image/jpeg',
            ],
        ];

        foreach ($teachers as $t) {
            Teacher::create($t);
        }
    }
}
