import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonRail extends StatelessWidget {
  final double itemWidth;
  final double height;
  const SkeletonRail({super.key, required this.itemWidth, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(.4),
        highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(.8),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, __) => Container(
            width: itemWidth,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemCount: 6,
        ),
      ),
    );
  }
}
