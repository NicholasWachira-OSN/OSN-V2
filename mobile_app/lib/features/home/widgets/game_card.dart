import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final String badge; // e.g., LIVE, FINAL, UPCOMING
  final VoidCallback? onTap;
  const GameCard({super.key, required this.title, required this.thumbnailUrl, required this.badge, this.onTap});

  Color _badgeColor() {
    switch (badge.toUpperCase()) {
      case 'LIVE':
        return const Color(0xFFE53935);
      case 'FINAL':
        return const Color(0xFF43A047);
      default:
        return const Color(0xFF1976D2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.1)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: thumbnailUrl,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _badgeColor(),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: card,
      ),
    );
  }
}
