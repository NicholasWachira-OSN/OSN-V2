// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider_riverpod.dart';
import '../providers/theme_provider.dart';
import '../core/auth/auth_flow.dart';
import '../shared/widgets/primary_side_bar.dart';
import '../shared/widgets/footer_section.dart';

class BrowseScreen extends ConsumerWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final logo = isDark ? 'assets/images/osn-w.png' : 'assets/images/osn-d.png';
  final isLoggedIn = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      drawer: const PrimarySideBar(currentPath: '/browse'),
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => context.go('/'),
          child: Image.asset(logo, height: 40),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await AuthFlow.runLogout(
                    context: context,
                    logoutAction: () => ref.read(authProvider.notifier).logout(),
                    navigateTo: '/login',
                  );
                }
              },
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          // Sports
          SliverToBoxAdapter(
            child: _SectionHeader(title: 'Sports'),
          ),
          SliverToBoxAdapter(
            child: _RoundedItemsRail(
              items: _dummySports,
              onTap: (item) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected ${item.name}')),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // League
          SliverToBoxAdapter(
            child: _SectionHeader(title: 'League'),
          ),
          SliverToBoxAdapter(
            child: _RoundedItemsRail(
              items: _dummyLeagues,
              onTap: (item) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected ${item.name}')),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Tournament
          SliverToBoxAdapter(
            child: _SectionHeader(title: 'Tournament'),
          ),
          SliverToBoxAdapter(
            child: _RoundedItemsRail(
              items: _dummyTournaments,
              onTap: (item) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected ${item.name}')),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          const SliverToBoxAdapter(child: FooterSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// -------------------------------
// Dummy data models and sources
// -------------------------------

class _BrowseItem {
  final String name;
  final String imageUrl;
  const _BrowseItem({required this.name, required this.imageUrl});
}

// Use picsum seeded images for deterministic placeholders
String _img(String seed) => 'https://picsum.photos/seed/${Uri.encodeComponent(seed)}/300/300';

const _sportsNames = [
  'Football', 'Basketball', 'Rugby', 'Tennis', 'Cricket', 'Athletics', 'Boxing', 'Golf'
];
final List<_BrowseItem> _dummySports = _sportsNames
    .map((n) => _BrowseItem(name: n, imageUrl: _img('sport-$n')))
    .toList(growable: false);

const _leagueNames = [
  'Premier League', 'La Liga', 'Serie A', 'Bundesliga', 'NBA', 'NFL', 'NHL', 'MLB'
];
final List<_BrowseItem> _dummyLeagues = _leagueNames
    .map((n) => _BrowseItem(name: n, imageUrl: _img('league-$n')))
    .toList(growable: false);

const _tournamentNames = [
  'World Cup', 'Champions League', 'Europa League', 'Wimbledon', 'US Open', 'Super Bowl', 'AFCON', 'Copa América'
];
final List<_BrowseItem> _dummyTournaments = _tournamentNames
    .map((n) => _BrowseItem(name: n, imageUrl: _img('tournament-$n')))
    .toList(growable: false);

// -------------------------------
// UI widgets
// -------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _RoundedItemsRail extends StatelessWidget {
  final List<_BrowseItem> items;
  final void Function(_BrowseItem) onTap;
  const _RoundedItemsRail({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Show large circular items. Cap visual width to roughly 4 items
    // while allowing horizontal scrolling for more.
    const double itemSize = 96;
    return SizedBox(
      height: itemSize + 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (ctx, i) {
          final item = items[i];
          return _RoundedItemCard(
            item: item,
            size: itemSize,
            onTap: () => onTap(item),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemCount: items.length,
      ),
    );
  }
}

class _RoundedItemCard extends StatelessWidget {
  final _BrowseItem item;
  final double size;
  final VoidCallback onTap;
  const _RoundedItemCard({required this.item, required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.outlineVariant;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor.withOpacity(0.4)),
              image: DecorationImage(
                image: NetworkImage(item.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: size,
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
