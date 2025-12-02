<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CharadesWords extends Model
{
    protected $fillable = [
        'charades_themes_id',
        'word'
    ];

    protected $primaryKey = 'id_charades_words';
    public $incrementing = true;
    protected $keyType = 'integer';

    public function charadesTheme(): BelongsTo
    {
        return $this->belongsTo(CharadesThemes::class, 'charades_themes_id', 'id_charades_themes');
    }
}