<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
// use App\Http\Controllers\V2\ArticleController;
use App\Http\Controllers\V2\Auth\MobileAuthController;
use App\Http\Controllers\V2\YouTubeController;
use App\Http\Resources\V2\UserResource;

Route::prefix('v2')->group(function () {
    // SPA session: use Fortify endpoints for login/register/logout under web middleware (handled by Fortify)
    // API User endpoint - relies on Sanctum's stateful session via cookies (no explicit 'web' group here)
    Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
        return new UserResource($request->user());
    });

    // Mobile-specific token login (kept for mobile apps using PATs)
    Route::post('/mobile/login', [MobileAuthController::class, 'login']);
    Route::post('/mobile/register', [MobileAuthController::class, 'register']);
    Route::middleware('auth:sanctum')->post('/mobile/logout', [MobileAuthController::class, 'logout']);

    // YouTube proxy endpoints
    Route::get('/youtube/video/{id}/live-details', [YouTubeController::class, 'liveDetails']);
});