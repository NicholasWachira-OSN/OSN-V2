class VideoItem {
  final String title;
  final String url; // Can be http(s) URL
  final String? posterUrl; // Optional thumbnail/poster image

  const VideoItem({required this.title, required this.url, this.posterUrl});

  bool get hasUrl => url.isNotEmpty;
}
