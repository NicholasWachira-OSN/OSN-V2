// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/theme_provider.dart';
import '../shared/widgets/primary_side_bar.dart';
import '../features/video/providers/current_video_provider.dart';
import '../features/video/widgets/basic_poster_player.dart';
import '../features/video/widgets/dropbox_video_player.dart';

class VideoScreen extends ConsumerStatefulWidget {
  final String? url;
  final String? title;
  final String? poster;
  const VideoScreen({super.key, this.url, this.title, this.poster});

  @override
  ConsumerState<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final logo = isDark ? 'assets/images/osn-w.png' : 'assets/images/osn-d.png';
    final current = ref.watch(currentVideoProvider);

    return Scaffold(
      drawer: const PrimarySideBar(currentPath: '/video'),
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
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player area
            AspectRatio(
              aspectRatio: 16 / 9,
              child: (widget.url ?? current.url).isNotEmpty
                  ? DropboxVideoPlayer(
                      url: widget.url ?? current.url,
                      title: widget.title ?? current.title,
                    )
                  : BasicPosterPlayer(
                      posterUrl: widget.poster ?? current.posterUrl,
                      title: widget.title ?? current.title,
                      url: widget.url ?? current.url,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title ?? current.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text('Playing via in-app player with controls. Use the menu to open externally if needed.'),
                ],
              ),
            ),
            TabBar(
              isScrollable: false,
              labelPadding: const EdgeInsets.symmetric(vertical: 10),
              controller: _tabController,
              tabs: const [
                Tab(text: 'Game Stats'),
                Tab(text: 'Past Results'),
                Tab(text: 'Info'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _GameStatsTab(),
                  _PastResultsTab(),
                  _InfoTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// (Removed NotLiveChatPlaceholder: chat tab is hidden entirely when not live)

class _GameStatsTab extends StatelessWidget {
  const _GameStatsTab();
  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Field Goals', '48%'),
      ('3PT', '37%'),
      ('Free Throws', '82%'),
      ('Rebounds', '42'),
      ('Assists', '19'),
      ('Steals', '9'),
      ('Blocks', '6'),
      ('Turnovers', '11'),
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: rows.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final (label, value) = rows[i];
        return ListTile(
          dense: true,
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        );
      },
    );
  }
}

class _PastResultsTab extends StatelessWidget {
  const _PastResultsTab();
  @override
  Widget build(BuildContext context) {
    final games = [
      ('Rivers 88 - 81 Patriots', 'FINAL • Oct 21, 2025'),
      ('Kampala 74 - 76 Nairobi', 'FINAL • Oct 15, 2025'),
      ('Mombasa 90 - 87 Dar Stars', 'FINAL • Oct 08, 2025'),
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final (score, meta) = games[i];
        return ListTile(
          title: Text(score, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(meta),
          leading: const Icon(Icons.sports_basketball_outlined),
        );
      },
    );
  }
}

class _InfoTab extends StatelessWidget {
  const _InfoTab();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Match info and description will appear here. We can surface lineup details, venue, referees, and broadcast rights.',
      ),
    );
  }
}
