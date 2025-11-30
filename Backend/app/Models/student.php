<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class student extends Model
{
    protected $fillable = [
    "id_students", 
    "classes_id", 
    "student_name",
];

public function student_to_classes(): BelongsTo
{
    return $this->belongsTo(classes::class,'classes_id');
}

    protected $primaryKey = 'id_students';
    public $incrementing = false;
    protected $keyType = 'integer';
}