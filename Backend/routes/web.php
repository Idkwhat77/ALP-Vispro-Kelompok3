<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

// Admin panel routes
Route::get('/admin', function () {
    return view('admin.login');
})->name('admin.login');

// Add this named login route that Laravel expects
Route::get('/login', function () {
    return view('admin.login');
})->name('login');

Route::get('/admin/dashboard', function () {
    return view('admin.dashboard');
})->name('admin.dashboard');