import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logo = isDark ? 'assets/images/osn-w.png' : 'assets/images/osn-d.png';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(logo, height: 36, fit: BoxFit.contain),
          const SizedBox(height: 12),
          Text(
            'Stream pay-per-view games, explore exclusive stats, and enjoy African basketball content on-demand.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(.8),
                  height: 1.4,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Divider(color: Theme.of(context).dividerColor.withOpacity(.2)),
          const SizedBox(height: 12),
          Text(
            '© ${DateTime.now().year} OSN Sports · All rights reserved',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
