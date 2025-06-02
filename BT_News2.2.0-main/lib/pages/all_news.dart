// Tüm haberlerin listelendiği sayfa
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Ağ üzerinden görsel önbellekleme
import 'package:bt_news/widget/custom_app_bar.dart'; // Özel üst bar widget'ı
import '../models/article_model.dart'; // Haber modeli
import '../pages/article_view.dart'; // Habere tıklanınca gidilecek detay sayfası

// Ana sayfa widget'ı - gelen haber listesini gösterir
class AllNews extends StatelessWidget {
  final List<ArticleModel> articles; // Gösterilecek haber listesi
  const AllNews({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Özel AppBar
      body: ListView.builder(
        itemCount: articles.length, // Liste uzunluğu
        itemBuilder:
            (ctx, i) => _NewsCard(article: articles[i]), // Her haber için kart
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tek bir haber kartını temsil eden özel widget
class _NewsCard extends StatelessWidget {
  final ArticleModel article;
  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => ArticleView(
                    blogUrl: article.url,
                  ), // Habere tıklandığında detay sayfasına git
            ),
          ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        elevation: 2, // Gölgelendirme
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            // Sol tarafta haber görseli
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage, // Haber görseli URL'si
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                placeholder:
                    (_, __) => const Center(
                      child: CircularProgressIndicator(),
                    ), // Yüklenirken gösterilecek
                errorWidget:
                    (_, __, ___) => const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ), // Yüklenemezse
              ),
            ),

            const SizedBox(width: 10), // Görsel ile metin arası boşluk
            // Sağ tarafta başlık ve açıklama
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title, // Haber başlığı
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis, // Uzunsa "..." ile kes
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.description, // Haber açıklaması
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
