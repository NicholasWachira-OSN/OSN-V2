import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider_riverpod.dart';

class PrimarySideBar extends StatefulWidget {
  final String? currentPath;
  const PrimarySideBar({super.key, this.currentPath});

  @override
  State<PrimarySideBar> createState() => _PrimarySideBarState();
}

class _PrimarySideBarState extends State<PrimarySideBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _fades;
  late final List<Animation<Offset>> _slides;

  static const _items = <_Item>[
    _Item(label: 'Home', path: '/', icon: Icons.home_outlined),
    _Item(label: 'Watch', path: '/watch', icon: Icons.play_circle_outline),
    _Item(label: 'Browse', path: '/browse', icon: Icons.grid_view_outlined),
    _Item(label: 'Features', path: '/features', icon: Icons.star_border),
    _Item(label: 'Interviews', path: '/interviews', icon: Icons.mic_none),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fades = List.generate(_items.length, (i) {
      final start = (i * 0.08).clamp(0.0, 1.0);
      final end = (start + 0.5).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });
    _slides = List.generate(_items.length, (i) {
      final start = (i * 0.08).clamp(0.0, 1.0);
      final end = (start + 0.6).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Start the stagger once drawer is shown
    if (!_controller.isAnimating && _controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final location = widget.currentPath ?? '';

    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          // Glossy, opaque look with subtle gradient and sheen
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.alphaBlend(Colors.white.withOpacity(0.04), cs.surface),
              Color.alphaBlend(Colors.black.withOpacity(0.12), cs.surface),
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer(
            builder: (context, ref, _) {
              final auth = ref.watch(authProvider);
              final isLoggedIn = auth.isAuthenticated;
              final userName = auth.user?.name ?? '';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  'Navigate',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const Divider(height: 1),
              const SizedBox(height: 8),
              ...List.generate(_items.length, (i) {
                final item = _items[i];
                final bool isActive = _isActive(location, item.path);
                return FadeTransition(
                  opacity: _fades[i],
                  child: SlideTransition(
                    position: _slides[i],
                    child: _SideTile(
                      icon: item.icon,
                      label: item.label,
                      isActive: isActive,
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go(item.path);
                      },
                    ),
                  ),
                );
              }),

              const SizedBox(height: 12),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Text(
                  'Account',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),

              if (!isLoggedIn) ...[
                _SideTile(
                  icon: Icons.login,
                  label: 'Login',
                  isActive: _isActive(location, '/login'),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/login');
                  },
                ),
                _SideTile(
                  icon: Icons.person_add_alt,
                  label: 'Register',
                  isActive: _isActive(location, '/register'),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/register');
                  },
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: cs.primary,
                          child: const Icon(Icons.person, size: 18, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            userName.isEmpty ? 'Signed in' : userName,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const Spacer(),
              // Subtle sheen overlay at the bottom
              Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.white.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SideTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _SideTile({required this.icon, required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = isActive ? cs.primary.withOpacity(0.12) : Colors.transparent;
    final fg = isActive ? cs.primary : cs.onSurface.withOpacity(0.9);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Row(
          children: [
            // Left accent when active
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 3,
              height: 24,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isActive ? cs.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(icon, color: fg),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: fg, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item {
  final String label;
  final String path;
  final IconData icon;
  const _Item({required this.label, required this.path, required this.icon});
}

bool _isActive(String location, String path) {
  if (path == '/') return location == '/';
  if (location == path) return true;
  // Treat nested paths as active (e.g., /browse/league/123 keeps Browse active)
  return location.startsWith('$path/');
}
