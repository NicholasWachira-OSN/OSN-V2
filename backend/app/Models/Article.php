<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;

class Article extends Model implements HasMedia
{
    use HasFactory, SoftDeletes, InteractsWithMedia;

    protected $fillable = ['title', 'slug', 'category_id', 'tournament_id', 'tagline', 'author_id', 'description', 'is_published', 'is_top'];

    public function author()
    {
    	return $this->belongsTo(Author::class, 'author_id');
    }
    public function category()
    {
        return $this->belongsTo(Category::class, 'category_id');
    }

    public function tournament()
    {
    	return $this->belongsTo(Tournament::class, 'tournament_id');
    }
}
