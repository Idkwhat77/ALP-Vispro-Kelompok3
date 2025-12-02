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
        "email",
        "password",
    ];

    protected $primaryKey = 'teacher_id';
    public $incrementing = true;
    protected $keyType = 'integer';

    public function classes(): HasMany
    {
        return $this->hasMany(Classes::class, 'teacher_id', 'teacher_id');
    }

    public function charadesThemes(): HasMany
    {
        return $this->hasMany(CharadesThemes::class, 'teacher_id', 'teacher_id');
    }
}


