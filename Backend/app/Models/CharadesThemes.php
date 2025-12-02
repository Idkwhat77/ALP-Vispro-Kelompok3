<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class CharadesThemes extends Model
{
    protected $fillable = [
    "teacher_id", 
    "name", 
];

    protected $primaryKey = 'id_charades_themes';
    public $incrementing = true;
    protected $keyType = 'integer';

    public function themes_to_teacher(): BelongsTo
    {
        return $this->belongsTo(Teacher::class,'teacher_id', 'teacher_id');
    }

    public function charadesWords(): HasMany
    {
        return $this->hasMany(CharadesWords::class, 'charades_themes_id', 'id_charades_themes');
    }

    public function gameSessions(): HasMany
    {
        return $this->hasMany(GameSession::class, 'charades_theme_id', 'id_charades_themes');
    }
}


