<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class Tournament extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia;

    protected $fillable = ['title', 'description', 'slug', 'tournament_id', 'is_active', 'short_name', 'category_id'];

    public function articles()
    {
    	return $this->hasMany(Article::class)->latest();
    }

    public function fixtures()
    {
        return $this->hasMany(Fixture::class)->latest();
    }

    public function videoArticles()
    {
        return $this->hasMany(VideoArticle::class)->latest();
    }

    public function teams()
    {
    	return $this->hasMany(Team::class);
    }

    public function category()
    {
        return $this->belongsTo(Category::class, 'category_id');
    }
}
