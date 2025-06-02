// lib/models/slider_model.dart

/// Haberlerin slider (karusel) gösterimi için model sınıfı
class SliderModel {
  // Tüm haber verileri final yani sabittir (değiştirilemez)
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String content;

  /// Constructor - Tüm alanlar zorunludur (required)
  const SliderModel({
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.content,
  });

  /// JSON verisinden `SliderModel` nesnesi üretir
  factory SliderModel.fromJson(Map<String, dynamic> j) {
    final img =
        (j['urlToImage'] as String?)
            ?.trim(); // Görsel linkini boşluklardan arındır

    return SliderModel(
      author: j['author'] ?? 'Unknown', // null veya boş ise "Unknown"
      title: j['title'] ?? '', // null ise boş string
      description: j['description'] ?? '',
      url: j['url'] ?? '',
      urlToImage:
          (img != null && img.isNotEmpty)
              ? img
              : 'https://via.placeholder.com/600x400?text=No+Image', // Yedek görsel linki
      content: j['content'] ?? '',
    );
  }

  /// `SliderModel` nesnesini JSON formatına dönüştürür
  Map<String, dynamic> toJson() => {
    'author': author,
    'title': title,
    'description': description,
    'url': url,
    'urlToImage': urlToImage,
    'content': content,
  };
}
