<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CampaignPayments extends Model
{
    use HasFactory;

    protected $fillable = ['order_id', 'phone', 'amount', 'mpesa_trans_id'];
}
