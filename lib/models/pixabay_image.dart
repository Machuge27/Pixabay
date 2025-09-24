class PixabayImage {
  final int id;
  final String webformatURL;
  final String previewURL;
  final String user;
  final String tags;
  final int views;
  final int downloads;
  final int likes;

  PixabayImage({
    required this.id,
    required this.webformatURL,
    required this.previewURL,
    required this.user,
    required this.tags,
    required this.views,
    required this.downloads,
    required this.likes,
  });

  factory PixabayImage.fromJson(Map<String, dynamic> json) {
    return PixabayImage(
      id: json['id'],
      webformatURL: json['webformatURL'],
      previewURL: json['previewURL'],
      user: json['user'],
      tags: json['tags'],
      views: json['views'],
      downloads: json['downloads'],
      likes: json['likes'],
    );
  }
}