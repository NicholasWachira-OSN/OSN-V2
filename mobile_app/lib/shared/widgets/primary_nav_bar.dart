import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrimaryNavBar extends StatefulWidget {
  const PrimaryNavBar({super.key});

  @override
  State<PrimaryNavBar> createState() => _PrimaryNavBarState();
}

class _PrimaryNavBarState extends State<PrimaryNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _fades;
  late final List<Animation<Offset>> _slides;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Staggered animations left -> right
    const steps = 4;
    _fades = List.generate(steps, (i) {
      final start = (i * 0.08).clamp(0.0, 1.0);
      final end = (start + 0.5).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    _slides = List.generate(steps, (i) {
      final start = (i * 0.08).clamp(0.0, 1.0);
      final end = (start + 0.6).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(-0.3, 0), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ));
    });

    // Start animation shortly after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const items = <_NavItemData>[
      _NavItemData('Watch', '/watch'),
      _NavItemData('Browse', '/browse'),
      _NavItemData('Features', '/features'),
      _NavItemData('Schedule', '/schedule'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // Opaque, glossy look: rich dark gradient with a soft highlight overlay
          gradient: LinearGradient(
            colors: [
              Color.alphaBlend(Colors.white.withOpacity(0.02), colorScheme.surface),
              Color.alphaBlend(Colors.black.withOpacity(0.10), colorScheme.surface),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle glossy sheen overlay
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.07),
                        Colors.white.withOpacity(0.00),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(items.length, (i) {
                  final item = items[i];
                  return FadeTransition(
                    opacity: _fades[i],
                    child: SlideTransition(
                      position: _slides[i],
                      child: _NavButton(
                        label: item.label,
                        onTap: () => context.go(item.path),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  final String label;
  final String path;
  const _NavItemData(this.label, this.path);
}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NavButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = scheme.onSurface.withOpacity(0.85);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}

// no extensions
