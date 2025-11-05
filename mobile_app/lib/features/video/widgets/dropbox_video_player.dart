import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../utils/dropbox_url.dart';

class DropboxVideoPlayer extends StatefulWidget {
  final String url; // Dropbox share or direct
  final bool autoplay;
  final bool loop;
  final String? title;
  const DropboxVideoPlayer({super.key, required this.url, this.autoplay = true, this.loop = false, this.title});

  @override
  State<DropboxVideoPlayer> createState() => _DropboxVideoPlayerState();
}

class _DropboxVideoPlayerState extends State<DropboxVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final directUrl = toDropboxDirectUrl(widget.url);
    final v = VideoPlayerController.networkUrl(Uri.parse(directUrl));
    setState(() => _videoController = v);

    try {
      await v.initialize();
      await v.setLooping(widget.loop);
      final chewie = ChewieController(
        videoPlayerController: v,
        autoPlay: widget.autoplay,
        looping: widget.loop,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.redAccent,
          handleColor: Colors.white,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white38,
        ),
        additionalOptions: (context) => [
          OptionItem(
            onTap: (_) => _openExternally(),
            iconData: Icons.open_in_new,
            title: 'Open externally',
          ),
        ],
      );
      setState(() => _chewieController = chewie);
    } catch (_) {
      setState(() => _error = true);
    }
  }

  Future<void> _openExternally() async {
    final uri = Uri.tryParse(toDropboxDirectUrl(widget.url));
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return _ErrorPanel(onOpenExternally: _openExternally, title: widget.title);
    }
    if (_chewieController == null || _videoController == null || !_videoController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Chewie(controller: _chewieController!);
  }
}

class _ErrorPanel extends StatelessWidget {
  final VoidCallback onOpenExternally;
  final String? title;
  const _ErrorPanel({required this.onOpenExternally, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white70),
          const SizedBox(height: 8),
          Text(
            title ?? 'Playback error',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: onOpenExternally,
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open externally'),
          )
        ],
      ),
    );
  }
}
