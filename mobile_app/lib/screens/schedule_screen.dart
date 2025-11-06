// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider_riverpod.dart';
import '../providers/theme_provider.dart';
import '../core/auth/auth_flow.dart';
import '../shared/widgets/primary_side_bar.dart';
import '../shared/widgets/footer_section.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  // Dummy hierarchical data
  final Map<String, List<String>> _leaguesBySport = const {
    'Football': ['Premier League', 'La Liga', 'Serie A', 'Bundesliga'],
    'Basketball': ['NBA', 'EuroLeague'],
    'Rugby': ['Six Nations', 'Rugby Championship'],
    'Tennis': ['ATP', 'WTA'],
  };

  final Map<String, List<String>> _tournamentsByLeague = const {
    'Premier League': ['2025 Season'],
    'La Liga': ['2025 Season'],
    'Serie A': ['2025 Season'],
    'Bundesliga': ['2025 Season'],
    'NBA': ['Regular Season', 'Playoffs'],
    'EuroLeague': ['Regular Season'],
    'Six Nations': ['2025 Edition'],
    'Rugby Championship': ['2025 Edition'],
    'ATP': ['Wimbledon', 'US Open'],
    'WTA': ['Wimbledon', 'US Open'],
  };

  String? _sport;
  String? _league;
  String? _tournament;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _sport = _leaguesBySport.keys.first;
    _league = _leaguesBySport[_sport!]!.first;
    _tournament = _tournamentsByLeague[_league!]!.first;
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final logo = isDark ? 'assets/images/osn-w.png' : 'assets/images/osn-d.png';
    final isLoggedIn = ref.watch(authProvider).isAuthenticated;

    final leagues = _sport != null ? (_leaguesBySport[_sport!] ?? const []) : const <String>[];
    if (_league == null || !leagues.contains(_league)) {
      _league = leagues.isNotEmpty ? leagues.first : null;
    }
    final tournaments = _league != null ? (_tournamentsByLeague[_league!] ?? const []) : const <String>[];
    if (_tournament == null || !tournaments.contains(_tournament)) {
      _tournament = tournaments.isNotEmpty ? tournaments.first : null;
    }

    final games = _filterGames(_dummyGames(), _query, _sport, _league, _tournament);

    return Scaffold(
      drawer: const PrimarySideBar(currentPath: '/schedule'),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _FiltersBar(
                sport: _sport,
                league: _league,
                tournament: _tournament,
                sports: _leaguesBySport.keys.toList(),
                leagues: leagues,
                tournaments: tournaments,
                query: _query,
                onSportChanged: (v) => setState(() {
                  _sport = v;
                  _league = null;
                  _tournament = null;
                }),
                onLeagueChanged: (v) => setState(() {
                  _league = v;
                  _tournament = null;
                }),
                onTournamentChanged: (v) => setState(() => _tournament = v),
                onQueryChanged: (v) => setState(() => _query = v),
                onClear: () => setState(() {
                  _query = '';
                }),
              ),
            ),
          ),

          // Games list
          SliverList.separated(
            itemBuilder: (context, index) {
              final g = games[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: _GameCard(game: g),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 2),
            itemCount: games.length,
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          const SliverToBoxAdapter(child: FooterSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// -------------------------------
// Filters UI
// -------------------------------

class _FiltersBar extends StatelessWidget {
  final String? sport;
  final String? league;
  final String? tournament;
  final List<String> sports;
  final List<String> leagues;
  final List<String> tournaments;
  final String query;
  final ValueChanged<String?> onSportChanged;
  final ValueChanged<String?> onLeagueChanged;
  final ValueChanged<String?> onTournamentChanged;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;

  const _FiltersBar({
    required this.sport,
    required this.league,
    required this.tournament,
    required this.sports,
    required this.leagues,
    required this.tournaments,
    required this.query,
    required this.onSportChanged,
    required this.onLeagueChanged,
    required this.onTournamentChanged,
    required this.onQueryChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    Widget dropdown<T>({
      required String label,
      required List<String> values,
      required String? value,
      required ValueChanged<String?> onChanged,
      IconData icon = Icons.arrow_drop_down,
    }) {
      return Expanded(
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: (value != null && values.contains(value)) ? value : null,
              hint: Text('Select'),
              icon: Icon(icon),
              items: values
                  .map((v) => DropdownMenuItem<String>(
                        value: v,
                        child: Text(v, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      );
    }

    final searchField = TextField(
      onChanged: onQueryChanged,
      controller: TextEditingController(text: query),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: query.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClear,
              )
            : null,
        hintText: 'Search teams or leagues',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top row: 3 dropdowns
        LayoutBuilder(builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 700;
          final children = [
            dropdown(label: 'Sport', values: sports, value: sport, onChanged: onSportChanged),
            const SizedBox(width: 12),
            dropdown(label: 'League', values: leagues, value: league, onChanged: onLeagueChanged),
            const SizedBox(width: 12),
            dropdown(label: 'Tournament', values: tournaments, value: tournament, onChanged: onTournamentChanged),
          ];
          if (isNarrow) {
            return Column(
              children: [
                Row(children: [children[0]]),
                const SizedBox(height: 12),
                Row(children: [children[2]]),
                const SizedBox(height: 12),
                Row(children: [children[4]]),
              ],
            );
          }
          return Row(children: children);
        }),
        const SizedBox(height: 12),
        // Search bar
        searchField,
      ],
    );
  }
}

// -------------------------------
// Dummy games data & models
// -------------------------------

enum GameStatus { live, scheduled, finaled }

class Game {
  final String sport;
  final String league;
  final String tournament;
  final String homeTeam;
  final String awayTeam;
  final int? homeScore;
  final int? awayScore;
  final DateTime dateTime;
  final GameStatus status;
  Game({
    required this.sport,
    required this.league,
    required this.tournament,
    required this.homeTeam,
    required this.awayTeam,
    required this.dateTime,
    required this.status,
    this.homeScore,
    this.awayScore,
  });
}

List<Game> _dummyGames() {
  final now = DateTime.now();
  return [
    Game(
      sport: 'Football',
      league: 'Premier League',
      tournament: '2025 Season',
      homeTeam: 'Manchester City',
      awayTeam: 'Arsenal',
      dateTime: now.add(const Duration(hours: 2)),
      status: GameStatus.scheduled,
    ),
    Game(
      sport: 'Football',
      league: 'La Liga',
      tournament: '2025 Season',
      homeTeam: 'Real Madrid',
      awayTeam: 'Barcelona',
      dateTime: now.subtract(const Duration(minutes: 20)),
      status: GameStatus.live,
      homeScore: 1,
      awayScore: 0,
    ),
    Game(
      sport: 'Basketball',
      league: 'NBA',
      tournament: 'Regular Season',
      homeTeam: 'Lakers',
      awayTeam: 'Warriors',
      dateTime: now.subtract(const Duration(days: 1, hours: 3)),
      status: GameStatus.finaled,
      homeScore: 104,
      awayScore: 99,
    ),
    Game(
      sport: 'Tennis',
      league: 'ATP',
      tournament: 'Wimbledon',
      homeTeam: 'Djokovic',
      awayTeam: 'Alcaraz',
      dateTime: now.add(const Duration(days: 1)),
      status: GameStatus.scheduled,
    ),
    Game(
      sport: 'Rugby',
      league: 'Six Nations',
      tournament: '2025 Edition',
      homeTeam: 'England',
      awayTeam: 'Ireland',
      dateTime: now.add(const Duration(days: 3, hours: 5)),
      status: GameStatus.scheduled,
    ),
  ];
}

List<Game> _filterGames(List<Game> all, String query, String? sport, String? league, String? tournament) {
  return all.where((g) {
    final q = query.trim().toLowerCase();
    final matchesQuery = q.isEmpty ||
        g.homeTeam.toLowerCase().contains(q) ||
        g.awayTeam.toLowerCase().contains(q) ||
        g.league.toLowerCase().contains(q);
    final matchesSport = sport == null || g.sport == sport;
    final matchesLeague = league == null || g.league == league;
    final matchesTournament = tournament == null || g.tournament == tournament;
    return matchesQuery && matchesSport && matchesLeague && matchesTournament;
  }).toList();
}

String _logoUrl(String seed) => 'https://picsum.photos/seed/${Uri.encodeComponent(seed)}/80/80';

class _GameCard extends StatelessWidget {
  final Game game;
  const _GameCard({required this.game});

  Color _statusColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    switch (game.status) {
      case GameStatus.live:
        return Colors.redAccent;
      case GameStatus.scheduled:
        return cs.tertiary;
      case GameStatus.finaled:
        return cs.primary;
    }
  }

  String _statusText() {
    switch (game.status) {
      case GameStatus.live:
        return 'LIVE';
      case GameStatus.scheduled:
        return 'SCHEDULED';
      case GameStatus.finaled:
        return 'FINAL';
    }
  }

  String _formatDateTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    final d = '${dt.year}-${two(dt.month)}-${two(dt.day)}';
    final t = '${two(dt.hour)}:${two(dt.minute)}';
    return '$d $t';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(context).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _statusColor(context).withOpacity(0.4)),
                ),
                child: Text(
                  _statusText(),
                  style: TextStyle(
                    color: _statusColor(context),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  game.league,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDateTime(game.dateTime),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Home
              _TeamCell(name: game.homeTeam, score: game.homeScore, logoUrl: _logoUrl(game.homeTeam)),
              const Spacer(),
              Text('vs', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              // Away
              _TeamCell(name: game.awayTeam, score: game.awayScore, logoUrl: _logoUrl(game.awayTeam), alignEnd: true),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tournament: ${game.tournament}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          )
        ],
      ),
    );
  }
}

class _TeamCell extends StatelessWidget {
  final String name;
  final int? score;
  final String logoUrl;
  final bool alignEnd;
  const _TeamCell({required this.name, required this.score, required this.logoUrl, this.alignEnd = false});

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final rowChildren = <Widget>[
      CircleAvatar(backgroundImage: NetworkImage(logoUrl), radius: 22),
      const SizedBox(width: 10),
      Flexible(
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: txt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      const SizedBox(width: 8),
      if (score != null)
        Text(
          score.toString(),
          style: txt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
    ];

    return SizedBox(
      width: 140,
      child: Row(
        mainAxisAlignment: alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: alignEnd ? rowChildren.reversed.toList() : rowChildren,
      ),
    );
  }
}
