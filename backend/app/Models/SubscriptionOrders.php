<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use LucasDotVin\Soulbscription\Models\Plan;

class SubscriptionOrders extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['user_id', 'plan_id', 'transaction_id', 'status', 'phone_number', 'amount'];

    public function user()
    {
      return $this->belongsTo(User::class);
    }

    public function plan()
    {
    	return $this->belongsTo(Plan::class, 'plan_id');
    }
}
