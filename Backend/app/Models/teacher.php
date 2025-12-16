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
        'picture',
        'picture_mime',
    ];

    protected $appends = ['picture_url'];

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

    /**
     * Get the URL for the teacher's picture.
     */
    public function getPictureUrlAttribute(): ?string
    {
        return url('api/teachers/' . $this->teacher_id . '/picture');
    }
}


