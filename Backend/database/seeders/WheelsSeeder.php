<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Wheel;
use App\Models\Classes;

class WheelsSeeder extends Seeder
{
    public function run(): void
    {
        $classes = Classes::all();
        if ($classes->count() === 0) return;

        $results = ['A', 'B', 'C', 'D', 'E'];
        $i = 0;
        foreach ($results as $r) {
            Wheel::create([
                'classes_id' => $classes[$i % $classes->count()]->classes_id,
                'result' => $r,
            ]);
            $i++;
        }
    }
}
