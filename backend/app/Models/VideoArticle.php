<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Overtrue\LaravelSubscribe\Traits\Subscribable;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Laravel\Scout\Searchable;
use BeyondCode\Vouchers\Traits\HasVouchers;

class VideoArticle extends Model implements HasMedia
{
    use HasFactory, SoftDeletes, InteractsWithMedia, Searchable, Subscribable, HasVouchers;

    protected $fillable = ['title', 'slug', 'description', 'category_id', 'video_link', 'is_published', 'is_premieum', 'video_category_id', 'tournament_id', 'is_live', 'price'];

    public function tournament()
    {
        return $this->belongsTo(Tournament::class, 'tournament_id');
    }

    public function videoCategory()
    {
        return $this->belongsTo(VideoCategory::class, 'video_category_id');
    }

    public function category()
    {
        return $this->belongsTo(Category::class, 'category_id');
    }

    public function toSearchableArray()
    {
        return [
            'title' => $this->title,
        ];
    }
}
