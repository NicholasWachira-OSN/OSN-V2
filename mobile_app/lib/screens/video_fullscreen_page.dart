import 'package:flutter/material.dart';

// Removed: Fullscreen YouTube player page. Placeholder only.
class VideoFullscreenPage extends StatelessWidget {
  final String videoId;
  const VideoFullscreenPage({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fullscreen (removed)')),
      body: const Center(child: Text('Fullscreen player removed')),
    );
  }
}
