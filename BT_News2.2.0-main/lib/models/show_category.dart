// Haber kategorilerine ait verileri temsil eden model sınıfı
class ShowCategoryModel {
  final String title, description, url, urlToImage, content, author;

  // Sabit (immutable) constructor - Tüm alanlar required
  const ShowCategoryModel({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.content,
    required this.author,
  });

  // JSON verisinden model nesnesi oluşturur (Factory constructor)
  factory ShowCategoryModel.fromJson(Map<String, dynamic> j) {
    final img =
        (j['urlToImage'] as String?)
            ?.trim(); // Görsel URL’si boş olabilir, bu yüzden kontrol yapılıyor

    return ShowCategoryModel(
      title: j['title'] ?? '', // Başlık boşsa boş string döner
      description: j['description'] ?? '', // Açıklama
      url: j['url'] ?? '', // Haberin orijinal URL'si
      urlToImage:
          (img != null && img.isNotEmpty)
              // Geçerli bir görsel URL’si varsa kullanılır, yoksa placeholder
              ? img
              : 'https://via.placeholder.com/600x400?text=No+Image',
      content: j['content'] ?? '', // İçerik
      author: j['author'] ?? 'Unknown', // Yazar adı boşsa 'Unknown'
    );
  }
}
