<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class classes extends Model
{
    protected $fillable = [
    "classes_id", 
    "teacher_id", 
    "class_name",
];




public function classes_to_teachers(): HasMany
{
    return $this->hasMany(teacher::class, 'teacher_id');
}

    protected $primaryKey = 'classes_id';
    public $incrementing = false;
    protected $keyType = 'integer';
}