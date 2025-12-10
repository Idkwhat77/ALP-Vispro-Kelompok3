<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Teacher extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;
    
    protected $fillable = [
        "username",
        "fullname",
        "email", 
        "password",
        "specialist",
        "picture",
        "picture_mime",
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $primaryKey = 'teacher_id';
    public $incrementing = true;
    protected $keyType = 'integer';

    // Route model binding key
    public function getRouteKeyName()
    {
        return 'teacher_id';
    }

    public function classes(): HasMany
    {
        return $this->hasMany(Classes::class, 'teacher_id', 'teacher_id');
    }

    public function charadesThemes(): HasMany
    {
        return $this->hasMany(CharadesThemes::class, 'teacher_id', 'teacher_id');
    }

    public function gameSessions(): HasMany
    {
        return $this->hasMany(GameSession::class, 'teacher_id', 'teacher_id');
    }
}


