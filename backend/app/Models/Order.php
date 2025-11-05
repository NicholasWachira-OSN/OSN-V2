<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Order extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['user_id', 'video_article_id', 'transaction_id', 'status', 'phone_number', 'amount'];

    public function user()
    {
      return $this->belongsTo(User::class);
    }

    public function videoArticle()
    {
    	return $this->belongsTo(VideoArticle::class, 'video_article_id');
    }

}