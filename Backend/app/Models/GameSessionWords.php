<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class GameSessionWords extends Model
{
    /**
     * Explicit table name to match migration: 'game_sessions_words'
     * (model class name would otherwise map to 'game_session_words').
     */
    protected $table = 'game_sessions_words';
    protected $fillable = [
        'game_session_id',
        'charades_words_id'
    ];

    protected $primaryKey = 'id_game_sessions_words';
    public $incrementing = true;
    protected $keyType = 'integer';

    public function gameSession(): BelongsTo
    {
        return $this->belongsTo(GameSession::class, 'game_session_id', 'id_game_sessions');
    }

    public function charadesWord(): BelongsTo
    {
        return $this->belongsTo(CharadesWords::class, 'charades_words_id', 'id_charades_words');
    }
}