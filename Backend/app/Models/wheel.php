<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Wheel extends Model
{
    protected $fillable = [
        "classes_id", 
        "result",
    ];

    protected $primaryKey = 'id_wheel';
    public $incrementing = true;
    protected $keyType = 'integer';

    public function histories(): HasMany
    {
        return $this->hasMany(History::class, 'wheel_id', 'id_wheel');
    }
    public function class(): BelongsTo
    {
        return $this->belongsTo(Classes::class, 'classes_id', 'classes_id');
    }
}