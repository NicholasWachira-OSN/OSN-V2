<?php

namespace App\Http\Controllers\V2\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

/**
 * Deprecated: Fortify now handles SPA logout.
 * Use POST /logout (with credentials) after login.
 */
class LogoutController extends Controller
{
    public function logout(Request $request)
    {
        abort(410, 'Deprecated: Use Laravel Fortify /logout');
    }
}
