import 'package:flutter/material.dart';

import 'league_card.dart';
import 'section_header.dart';
import 'skeleton_rail.dart';

class LeagueRail extends StatelessWidget {
  const LeagueRail({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated async load (replace with provider later)
    return FutureBuilder<void>(
      future: Future<void>.delayed(const Duration(milliseconds: 500)),
      builder: (context, snapshot) {
        final loading = snapshot.connectionState != ConnectionState.done;
        if (loading) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'Leagues'),
              SkeletonRail(itemWidth: 160, height: 140),
            ],
          );
        }

        final leagues = [
          (
            'Basketball Africa League',
            'https://images.unsplash.com/photo-1519861531473-9200262188bf?q=80&w=1200&auto=format&fit=crop',
          ),
          (
            'WNBA Africa',
            'https://images.unsplash.com/photo-1517466787929-bc90951d0974?q=80&w=1200&auto=format&fit=crop',
          ),
          (
            'Kenya Premier Hoops',
            'https://images.unsplash.com/photo-1517649763962-0c623066013b?q=80&w=1200&auto=format&fit=crop',
          ),
          (
            'Rwanda Elite League',
            'https://images.unsplash.com/photo-1517466787929-bc90951d0974?q=80&w=1200&auto=format&fit=crop',
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Leagues'),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: leagues.length,
                itemBuilder: (context, i) {
                  final (name, url) = leagues[i];
                  return LeagueCard(name: name, imageUrl: url);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
