<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class CampaignOrder extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['transaction_id', 'user_id', 'status', 'phone_number', 'full_name', 'email', 'amount'];

    public function user()
    {
    	return $this->belongsTo(User::class, 'user_id');
    }
}
