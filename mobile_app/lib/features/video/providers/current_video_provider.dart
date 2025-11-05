import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/video_item.dart';

class CurrentVideoController extends StateNotifier<VideoItem> {
  CurrentVideoController()
      : super(const VideoItem(
          title: 'No video selected',
          url: '',
          posterUrl: null,
        ));

  void setVideo({required String title, required String url, String? posterUrl}) {
    state = VideoItem(title: title, url: url, posterUrl: posterUrl);
  }
}

final currentVideoProvider = StateNotifierProvider<CurrentVideoController, VideoItem>((ref) {
  return CurrentVideoController();
});
