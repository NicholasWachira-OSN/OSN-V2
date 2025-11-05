<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class SpaAuthTest extends TestCase
{
    use RefreshDatabase;

    public function test_authenticated_user_is_returned_across_consecutive_requests(): void
    {
        $user = User::factory()->create();

        // Simulate an authenticated session for the web guard
        $this->actingAs($user);

        // First request
        $first = $this->get('/api/v2/user');
        $first->assertOk();
        $first->assertJsonFragment([
            'id' => $user->id,
            'email' => $user->email,
        ]);

        // Second request (simulates a second refresh)
        $second = $this->get('/api/v2/user');
        $second->assertOk();
        $second->assertJsonFragment([
            'id' => $user->id,
            'email' => $user->email,
        ]);
    }
}
