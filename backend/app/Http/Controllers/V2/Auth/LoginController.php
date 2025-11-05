<?php

namespace App\Http\Controllers\V2\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

/**
 * Deprecated: Fortify now handles SPA authentication.
 * Use POST /login after GET /sanctum/csrf-cookie.
 */
class LoginController extends Controller
{
    public function login(Request $request)
    {
        abort(410, 'Deprecated: Use Laravel Fortify /login');
    }
}
