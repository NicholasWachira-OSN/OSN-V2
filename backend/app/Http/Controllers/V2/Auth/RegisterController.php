<?php

namespace App\Http\Controllers\V2\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

/**
 * Deprecated: Fortify now handles SPA registration.
 * Use POST /register after GET /sanctum/csrf-cookie.
 */
class RegisterController extends Controller
{
    public function register(Request $request)
    {
        abort(410, 'Deprecated: Use Laravel Fortify /register');
    }
}
