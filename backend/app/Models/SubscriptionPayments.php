<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SubscriptionPayments extends Model
{
    use HasFactory;

    protected $fillable = ['user_id', 'subscription_orders_id', 'phone', 'amount', 'mpesa_trans_id'];

}
