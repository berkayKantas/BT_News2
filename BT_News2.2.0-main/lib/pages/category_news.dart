// Kategoriye göre haberleri listeleyen sayfa

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Ağ üzerinden görselleri önbellekli gösterme
import 'package:bt_news/widget/custom_app_bar.dart'; // Özel app bar
import '../models/show_category.dart'; // Kategoriye özel haber modeli
import '../pages/article_view.dart'; // Haber detay ekranı
import '../services/show_category_news.dart'; // Haber verisini API'den çekme servisi

// ─────────────────────────────────────────────────────────────────────────────
// Kategoriye göre haberleri listeleyen stateful widget
class CategoryNews extends StatefulWidget {
  final String name; // Kategori adı
  const CategoryNews({super.key, required this.name});

  @override
  State<CategoryNews> createState() => _CategoryNewsPageState();
}

class _CategoryNewsPageState extends State<CategoryNews> {
  final List<ShowCategoryModel> _articles = []; // Gelen haberlerin listesi
  bool _loading = true; // Yüklenme durumu

  @override
  void initState() {
    super.initState();
    _fetch(); // Sayfa yüklendiğinde haberleri getir
  }

  // Kategoriye özel haberleri API'den çekme işlemi
  Future<void> _fetch() async {
    final svc = ShowCategoryNews();
    await svc.getCategoriesNews(
      widget.name.toLowerCase(),
    ); // Kategori adı küçük harfle gönderiliyor
    setState(() {
      _articles
        ..clear()
        ..addAll(svc.categories); // Veriler güncelleniyor
      _loading = false; // Yükleme tamamlandı
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Uygulamanın özel app bar'ı
      body:
          _loading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Veri gelene kadar yüklenme göstergesi
              : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount:
                    _articles.length, // Gelen haber sayısı kadar kart göster
                itemBuilder:
                    (ctx, i) => _CategoryCard(
                      article: _articles[i],
                    ), // Her haber için kart widget'ı
              ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tek bir kategori haberini gösteren kart widget'ı
class _CategoryCard extends StatelessWidget {
  final ShowCategoryModel article;
  const _CategoryCard({required this.article});

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
                  ), // Kart tıklanınca detay sayfasına geç
            ),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Haber görseli
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: article.urlToImage, // Görsel URL’si
              height: 200,
              width: MediaQuery.of(context).size.width, // Ekran genişliği kadar
              fit: BoxFit.cover, // Görseli orantılı şekilde doldur
              placeholder:
                  (_, __) => const Center(
                    child: CircularProgressIndicator(),
                  ), // Yüklenirken gösterilecek
              errorWidget:
                  (_, __, ___) => const Icon(
                    Icons.broken_image,
                    size: 64,
                    color: Colors.grey,
                  ), // Hatalıysa ikon
            ),
          ),
          const SizedBox(height: 6),
          // Haber başlığı
          Text(
            article.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          // Haber açıklaması
          Text(
            article.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20), // Her kart arası boşluk
        ],
      ),
    );
  }
}
