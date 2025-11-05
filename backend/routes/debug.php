<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;

Route::get('/debug/session', function (Request $request) {
    return response()->json([
        'session_id' => session()->getId(),
        'session_driver' => config('session.driver'),
        'session_cookie_name' => config('session.cookie'),
        'session_domain' => config('session.domain'),
        'session_path' => config('session.path'),
        'session_same_site' => config('session.same_site'),
        'session_secure' => config('session.secure'),
        'session_http_only' => config('session.http_only'),
        'has_session_data' => $request->session()->all(),
        'cookies_sent' => $request->cookies->all(),
        'user_authenticated' => auth()->check(),
        'user_id' => auth()->id(),
    ]);
});
