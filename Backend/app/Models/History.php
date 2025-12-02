<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class History extends Model
{
    protected $table = 'history';
    protected $fillable = [
        'game_session_id',
        'wheel_id'
    ];

    protected $primaryKey = 'id_history';
    public $incrementing = true;
    protected $keyType = 'integer';

    public function gameSession(): BelongsTo
    {
        return $this->belongsTo(GameSession::class, 'game_session_id', 'id_game_sessions');
    }

    public function wheel(): BelongsTo
    {
        return $this->belongsTo(Wheel::class, 'wheel_id', 'id_wheel');
    }
}