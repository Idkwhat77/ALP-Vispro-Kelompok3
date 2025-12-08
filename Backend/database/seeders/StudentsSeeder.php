<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Student;
use App\Models\Classes;

class StudentsSeeder extends Seeder
{
    public function run(): void
    {
        $classes = Classes::all();
        if ($classes->count() === 0) return;

        $studentNames = [
            'Budi Santoso', 'Siti Nurhaliza', 'Ahmad Wijaya', 'Dewi Lestari', 'Roni Hermawan',
            'Maya Putri', 'Arjun Prabowo', 'Lina Wijaksono', 'Doni Setiawan', 'Eka Prasetya',
            'Farah Nabila', 'Gading Marten', 'Hendra Kusuma', 'Intan Ratna', 'Joko Anwar',
            'Kirana Larasati', 'Juanda Hakim', 'Mira Lesmana', 'Nanang Bustami', 'Oki Setiana',
            'Putri Handayani', 'Quincy Jones', 'Raden Saleh', 'Sari Kusuma', 'Tono Supriyanto',
            'Uki Wijaya', 'Vina Maharani', 'Wahyu Darmodjo', 'Xander Lee', 'Yusuf Rahman',
            'Zainul Arifin', 'Amelia Gunawan', 'Bambang Sutrisno', 'Cecilia Wijaya', 'Dedi Gunawan',
            'Eni Soewandi', 'Fajar Satria', 'Gita Savitri', 'Hendrik Sihotang', 'Indah Permata',
            'Jamal Mirdad', 'Kamal Gazaley', 'Landi Budiman', 'Maudy Ayunda', 'Nandy Dwi',
            'Opa Sinaga', 'Pujiono Sinaga', 'Qasim Nugraha', 'Rasta Putra', 'Sopo Jarwo',
            'Taufik Hidayat', 'Ujang Subeno', 'Vino Bastian', 'Wawan Ridho', 'Xenia Widjaya',
            'Yusep Gunawan', 'Zainal Arifin', 'Anita Chong', 'Bimo Aryo', 'Cantika Abigail',
            'Darius Sinatrio', 'Effy Handayani', 'Faisal Nasution', 'Gading Saputro', 'Hanung Bramantyo',
            'Ira Wibowo', 'Jajang Nurjaman', 'Kees Tol', 'Lina Marlina', 'Muhammad Irfan',
            'Nisrina Dwi', 'Ody Mulya', 'Palevi Simanjuntak', 'Qadri Rahman', 'Rida Noer',
            'Sahara Safira', 'Tania Gunawan', 'Usman Sutiksno', 'Vadhana Eka', 'Wahyu Santoso',
            'Xiomara Wijaya', 'Yunus Irawan', 'Zakia Nur', 'Aprilyanto Wijaya', 'Belinda Wijaya',
            'Citra Kusuma', 'Dipo Latief', 'Erwin Gutawan', 'Fadia Febrina', 'Galih Winarto',
            'Hamim Tohari', 'Inayah Larasati', 'Juwita Maharani', 'Karuniastuti Novembri', 'Lahir Gunawan',
            'Maya Permata', 'Naura Ayu', 'Obed Lawson', 'Praja Adhitya', 'Quilla Kusuma',
            'Reska Gita', 'Sabrina Marbun', 'Tarzan Syailendra', 'Ulfa Shinta', 'Vaganza Kusuma',
            'Wawan Iskandar', 'Sena Wijaya', 'Yuni Rahmawati', 'Zaida Nurmala',
            'Bagus Prasetyo', 'Candra Permana', 'Dian Anggraini', 'Eko Saputra', 'Fitria Dewi',
            'Gilang Ramadhan', 'Heru Santoso', 'Ika Wulandari', 'Johan Setiawan', 'Kartika Sari',
            'Lukman Hakim', 'Mega Sari', 'Novi Andriani', 'Oka Pratama', 'Putu Ardana',
            'Rizky Maulana', 'Sinta Maharani', 'Teguh Prabowo', 'Utami Lestari', 'Vera Oktaviani',
            'Wira Gunawan', 'Yani Susanti', 'Zaki Pratama', 'Ayu Lestari', 'Bambang Riyadi',
            'Cici Paramita', 'Dewi Sartika', 'Endang Sulastri', 'Fauzi Ramli', 'Gita Pratiwi',
            'Hadi Saputra', 'Intan Sari', 'Joko Susilo', 'Kiki Amalia', 'Lia Kusuma',
            'Mulyadi Saputra', 'Nina Kurnia', 'Andi Pratama', 'Putra Wijaya', 'Rina Oktaviani',
            'Samsul Hadi',
        ];

        $i = 0;
        foreach ($studentNames as $name) {
            Student::create([
                'classes_id' => $classes[$i % $classes->count()]->classes_id,
                'student_name' => $name,
            ]);
            $i++;
        }
    }
}
