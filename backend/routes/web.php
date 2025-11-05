<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use Laravel\Fortify\Http\Controllers\AuthenticatedSessionController;
use Laravel\Fortify\Http\Controllers\RegisteredUserController;

Route::get('/', function () {
    return view('welcome');
});

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
        'user_authenticated' => auth()->check(),
        'user_id' => auth()->id(),
    ]);
});

// Temporary compatibility routes to support legacy SPA calls to /api/v2/*
// These forward to Fortify but remain under web middleware to preserve CSRF/session behavior.
Route::prefix('api/v2')->group(function () {
    Route::post('/login', [AuthenticatedSessionController::class, 'store'])->name('compat.v2.login');
    Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])->name('compat.v2.logout');
    Route::post('/register', [RegisteredUserController::class, 'store'])->name('compat.v2.register');
});