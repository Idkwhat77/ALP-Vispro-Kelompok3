<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class GameSession extends Model
{
    protected $fillable = [
        'class_id',
        'teacher_id',
        'charades_theme_id',
        'played_at',
        'total_guess_correct',
        'total_guess_skipped'
    ];

    protected $primaryKey = 'id_game_sessions';
    public $incrementing = true;
    protected $keyType = 'integer';

    public function class(): BelongsTo
    {
        return $this->belongsTo(Classes::class, 'class_id', 'classes_id');
    }

    public function teacher(): BelongsTo
    {
        return $this->belongsTo(Teacher::class, 'teacher_id', 'teacher_id');
    }

    public function charadesTheme(): BelongsTo
    {
        return $this->belongsTo(CharadesThemes::class, 'charades_theme_id', 'id_charades_themes');
    }

    public function gameSessionWords(): HasMany
    {
        return $this->hasMany(GameSessionWords::class, 'game_session_id', 'id_game_sessions');
    }

    public function histories(): HasMany
    {
        return $this->hasMany(History::class, 'game_session_id', 'id_game_sessions');
    }
}