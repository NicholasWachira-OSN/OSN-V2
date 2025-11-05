import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/reels_provider.dart';

/// Stateful: owns PageController, listens for page changes, and can manage
/// play/pause or prefetch logic later. For now, it shows full-screen media
/// placeholders (images) with vertical paging like Instagram Reels.
class ReelsViewerScreen extends ConsumerStatefulWidget {
  final int initialIndex;
  const ReelsViewerScreen({super.key, this.initialIndex = 0});

  @override
  ConsumerState<ReelsViewerScreen> createState() => _ReelsViewerScreenState();
}

class _ReelsViewerScreenState extends ConsumerState<ReelsViewerScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reels = ref.watch(reelsProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: reels.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              final reel = reels[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Media placeholder; swap with a real VideoPlayer later
                  Image.network(
                    reel.mediaUrl,
                    fit: BoxFit.cover,
                  ),
                  // Overlay gradient for readable text
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Color(0xCC000000),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                  // Minimal controls/labels
                  Positioned(
                    left: 16,
                    bottom: 24,
                    right: 16,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                reel.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Reel ${index + 1} of ${reels.length}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_border, color: Colors.white),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.comment_outlined, color: Colors.white),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.share_outlined, color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // Close/back button
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.close, color: cs.onPrimaryContainer),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
