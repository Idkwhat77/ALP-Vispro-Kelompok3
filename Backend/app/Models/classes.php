<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Classes extends Model
{
    protected $fillable = [
        "teacher_id", 
        "class_name",
    ];

    public function teacher(): BelongsTo
    {
        return $this->belongsTo(Teacher::class, 'teacher_id', 'teacher_id');
    }

    public function students(): HasMany
    {
        return $this->hasMany(Student::class, 'classes_id', 'classes_id');
    }

    public function wheels(): HasMany
    {
        return $this->hasMany(Wheel::class, 'classes_id', 'classes_id');
    }

    public function gameSessions(): HasMany
    {
        return $this->hasMany(GameSession::class, 'class_id', 'classes_id');
    }

    protected $primaryKey = 'classes_id';
    public $incrementing = true;
    protected $keyType = 'integer';
}