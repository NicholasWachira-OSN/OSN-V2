<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['name', 'slug','is_active'];

    public function articles()
    {
    	return $this->hasMany(Article::class);
    }
    public function tournaments()
    {
    	return $this->hasMany(Tournament::class);
    }
}
