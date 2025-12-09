<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Student extends Model
{
    protected $fillable = [
    "classes_id", 
    "student_name",
];

public function student_to_classes(): BelongsTo
{
    return $this->belongsTo(Classes::class,'classes_id', 'classes_id');
}

    protected $primaryKey = 'id_students';
    public $incrementing = true;
    protected $keyType = 'integer';

    // Route model binding key
    public function getRouteKeyName()
    {
        return 'id_students';
    }
}