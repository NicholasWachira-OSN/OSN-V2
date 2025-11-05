<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Model;

class VideoCategory extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['name', 'slug'];

    public function videoArticles()
    {
    	return $this->hasMany(VideoArticle::class)->with('media')->latest();
    }
}
