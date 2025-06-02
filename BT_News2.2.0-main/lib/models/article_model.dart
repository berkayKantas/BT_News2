// lib/models/article_model.dart
class ArticleModel {
  // ─── ALANLAR ─────────────────────────────────────────────
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String content;

  // ─── YAPICI (Constructor) ───────────────────────────────
  const ArticleModel({
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.content,
  });

  // ─── JSON’DAN NESNE ÜRET ────────────────────────────────
  factory ArticleModel.fromJson(Map<String, dynamic> j) {
    final rawImage = (j['urlToImage'] as String?)?.trim();
    return ArticleModel(
      author: j['author'] ?? 'Unknown',
      title: j['title'] ?? '',
      description: j['description'] ?? '',
      url: j['url'] ?? '',
      urlToImage:
          (rawImage != null && rawImage.isNotEmpty)
              ? rawImage
              : 'https://via.placeholder.com/600x400?text=No+Image',
      content: j['content'] ?? '',
    );
  }

  // (Opsiyonel) Firestore vb. için geri JSON’a çevir
  Map<String, dynamic> toJson() => {
    'author': author,
    'title': title,
    'description': description,
    'url': url,
    'urlToImage': urlToImage,
    'content': content,
  };
}
