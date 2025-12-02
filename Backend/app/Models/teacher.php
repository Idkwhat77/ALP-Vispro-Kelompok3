<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Teacher extends Model
{
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


