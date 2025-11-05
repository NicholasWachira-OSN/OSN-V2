import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BasicPosterPlayer extends StatelessWidget {
  final String? posterUrl;
  final String title;
  final String url;
  const BasicPosterPlayer({super.key, this.posterUrl, required this.title, required this.url});

  Future<void> _open() async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (posterUrl != null && posterUrl!.isNotEmpty)
          Image.network(posterUrl!, fit: BoxFit.cover)
        else
          Container(color: Colors.black12),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black54, Colors.transparent],
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
            onPressed: url.isEmpty ? null : _open,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Open externally'),
          ),
        ),
        Positioned(
          left: 12,
          bottom: 12,
          right: 12,
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  shadows: const [Shadow(color: Colors.black87, blurRadius: 6)],
                ),
          ),
        ),
      ],
    );
  }
}
