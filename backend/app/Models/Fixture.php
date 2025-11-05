<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Model;
use App\Models\Team;

class Fixture extends Model
{
    use HasFactory, SoftDeletes;

    protected $casts = [ 'scheduled_time'=>'datetime'];

    protected $fillable = ['team_a', 'team_b', 'scheduled_time', 'score_a', 'score_b', 'tournament_id', 'location'];
    
    public function teamName($id)
    {
        $team = Team::where('id', $id)->first();

        return $team;
    }
}
