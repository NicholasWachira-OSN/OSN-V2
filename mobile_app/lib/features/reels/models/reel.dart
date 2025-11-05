class Reel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String mediaUrl; // Could be video URL; we will mock with images for now

  const Reel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.mediaUrl,
  });
}
