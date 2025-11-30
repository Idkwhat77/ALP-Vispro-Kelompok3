<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class teacher extends Model
{
    protected $fillable = [
    "teacher_id", 
    "username", 
    "email", 
    "password",
];

    protected $primaryKey = 'teacher_id';
    public $incrementing = false;
    protected $keyType = 'integer';

}


