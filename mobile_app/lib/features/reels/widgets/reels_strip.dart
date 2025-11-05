import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../reels/providers/reels_provider.dart';

/// Stateless: purely renders based on provider state and sends navigation taps.
class ReelsStrip extends ConsumerWidget {
  const ReelsStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reels = ref.watch(reelsProvider);
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: 112,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: reels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final reel = reels[index];
          return GestureDetector(
            onTap: () {
              // Go to viewer at tapped index
              context.push('/reels?index=$index');
            },
            child: Column(
              children: [
                // Ringed circular thumbnail
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [cs.primary, cs.primary.withOpacity(0.4)],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: cs.surface,
                    backgroundImage: NetworkImage(reel.thumbnailUrl),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 84,
                  child: Text(
                    reel.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
