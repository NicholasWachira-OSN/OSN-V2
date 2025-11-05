import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/reel.dart';

// Mock reels provider (replace with API later)
final reelsProvider = Provider<List<Reel>>((ref) {
  return const [
    Reel(
      id: 'r1',
      title: 'SIEL',
      thumbnailUrl: 'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=400',
      mediaUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=1080',
    ),
    Reel(
      id: 'r2',
      title: 'City Thunder',
      thumbnailUrl: 'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=400',
      mediaUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=1080',
    ),
    Reel(
      id: 'r3',
      title: 'Finals',
      thumbnailUrl: 'https://images.unsplash.com/photo-1547347298-4074fc3086f0?w=400',
      mediaUrl: 'https://images.unsplash.com/photo-1547347298-4074fc3086f0?w=1080',
    ),
    Reel(
      id: 'r4',
      title: 'FIBA Basketball',
      thumbnailUrl: 'https://images.unsplash.com/photo-1505664194779-8beaceb93744?w=400',
      mediaUrl: 'https://images.unsplash.com/photo-1505664194779-8beaceb93744?w=1080',
    ),
    Reel(
      id: 'r5',
      title: 'roadToBal',
      thumbnailUrl: 'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=400',
      mediaUrl: 'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=1080',
    ),
  ];
});
