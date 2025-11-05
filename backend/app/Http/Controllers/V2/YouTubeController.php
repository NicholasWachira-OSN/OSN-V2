<?php

namespace App\Http\Controllers\V2;

use Illuminate\Http\Request;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Support\Facades\Http;

class YouTubeController extends BaseController
{
    public function liveDetails(string $id)
    {
        $apiKey = config('services.youtube.key');
        if (!$apiKey) {
            return response()->json([
                'isLive' => false,
                'reason' => 'missing_api_key',
            ]);
        }

        $response = Http::get('https://www.googleapis.com/youtube/v3/videos', [
            'part' => 'liveStreamingDetails,status',
            'id'   => $id,
            'key'  => $apiKey,
        ]);

        if (!$response->ok()) {
            return response()->json([
                'isLive' => false,
                'reason' => 'http_error',
                'status' => $response->status(),
            ]);
        }

        $data = $response->json();
        $item = $data['items'][0] ?? null;
        $live = $item['liveStreamingDetails'] ?? [];
        $status = $item['status'] ?? [];

        $activeChatId = $live['activeLiveChatId'] ?? null;
        $scheduledStartTime = $live['scheduledStartTime'] ?? null;
        $actualStartTime = $live['actualStartTime'] ?? null;
        $actualEndTime = $live['actualEndTime'] ?? null;
        $privacy = $status['privacyStatus'] ?? 'public';

        $isLive = !empty($activeChatId) && empty($actualEndTime);

        return response()->json([
            'isLive' => (bool) $isLive,
            'activeLiveChatId' => $activeChatId,
            'privacyStatus' => $privacy,
            'scheduledStartTime' => $scheduledStartTime,
            'actualStartTime' => $actualStartTime,
            'actualEndTime' => $actualEndTime,
        ]);
    }
}
