<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class PersonalAccessTokensSeeder extends Seeder
{
    public function run(): void
    {
        // insert 5 simple token records for testing purposes
        for ($i = 0; $i < 5; $i++) {
            DB::table('personal_access_tokens')->insert([
                'tokenable_type' => 'App\\Models\\Teacher',
                'tokenable_id' => $i + 1,
                'name' => 'seed-token-' . ($i + 1),
                'token' => hash('sha256', Str::random(40)),
                'abilities' => null,
                'last_used_at' => null,
                'expires_at' => Carbon::now()->addDays(30),
                'created_at' => Carbon::now(),
                'updated_at' => Carbon::now(),
            ]);
        }
    }
}
