<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class wheel extends Model
{
    protected $fillable = [
    "id_wheel", 
    "classes_id", 
    "result",
];

public function wheel_to_classes(): HasMany
{
    return $this->hasMany(classes::class,'classes_id');
}

    protected $primaryKey = 'id_wheel';
    public $incrementing = false;
    protected $keyType = 'integer';
}

