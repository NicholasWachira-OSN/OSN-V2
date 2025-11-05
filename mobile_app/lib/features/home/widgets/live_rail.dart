import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'game_card.dart';
import 'section_header.dart';
import 'skeleton_rail.dart';

class LiveRail extends StatelessWidget {
  const LiveRail({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Future<void>.delayed(const Duration(milliseconds: 650)),
      builder: (context, snapshot) {
        final loading = snapshot.connectionState != ConnectionState.done;
        if (loading) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'Live Now'),
              SkeletonRail(itemWidth: 220, height: 160),
            ],
          );
        }

        const dropboxShare =
            'https://www.dropbox.com/scl/fi/gdpt1ybmlsq01jvjzpipu/OSN-LIVE-01-November-2025-07-45-15-PM-00012.mp4?rlkey=zx5qf002kdraltf2re5sdermp&st=lpmernqw&dl=0';
        final games = [
          (
            'BAL Semifinals: Rivers vs Patriots',
            'https://images.unsplash.com/photo-1546519638-68e109498ffc?q=80&w=1200&auto=format&fit=crop',
            'LIVE',
            dropboxShare,
          ),
          (
            'Kenya Hoops: Nairobi vs Mombasa',
            'https://images.unsplash.com/photo-1517466787929-bc90951d0974?q=80&w=1200&auto=format&fit=crop',
            'LIVE',
            null,
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Live Now'),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: games.length,
                itemBuilder: (context, i) {
                  final (title, url, badge, vidUrl) = games[i];
                  return GameCard(
                    title: title,
                    thumbnailUrl: url,
                    badge: badge,
                    onTap: () {
                      if (vidUrl != null) {
                        final encUrl = Uri.encodeComponent(vidUrl);
                        final encTitle = Uri.encodeComponent(title);
                        final encPoster = Uri.encodeComponent(url);
                        context.go('/video?url=$encUrl&title=$encTitle&poster=$encPoster');
                      } else {
                        context.go('/video');
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
