import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../utils/dropbox_url.dart';

class NativeVideoPlayer extends StatefulWidget {
  final String url;
  final String? title;
  final bool loop;
  final bool autoplay;
  const NativeVideoPlayer({super.key, required this.url, this.title, this.loop = false, this.autoplay = true});

  @override
  State<NativeVideoPlayer> createState() => _NativeVideoPlayerState();
}

class _NativeVideoPlayerState extends State<NativeVideoPlayer> {
  VideoPlayerController? _controller;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final directUrl = toDropboxDirectUrl(widget.url);
      final c = VideoPlayerController.networkUrl(Uri.parse(directUrl));
      setState(() => _controller = c);
      await c.initialize();
      await c.setLooping(widget.loop);
      if (widget.autoplay) await c.play();
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return const Center(child: Text('Playback error', style: TextStyle(color: Colors.white)));
    }
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    final aspect = _controller!.value.aspectRatio == 0 ? 16 / 9 : _controller!.value.aspectRatio;
    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(aspectRatio: aspect, child: VideoPlayer(_controller!)),
        _ControlsOverlay(controller: _controller!),
        Align(
          alignment: Alignment.bottomCenter,
          child: VideoProgressIndicator(
            _controller!,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Colors.redAccent,
              bufferedColor: Colors.white24,
              backgroundColor: Colors.white12,
            ),
          ),
        ),
      ],
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;
  const _ControlsOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (controller.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
      },
      child: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: controller.value.isPlaying
                ? const SizedBox.shrink()
                : const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 72,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
