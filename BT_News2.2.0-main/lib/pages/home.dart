import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Slider için paket
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Sayfa göstergesi (dots)
import '../widget/drawer_menu.dart'; // Drawer menüsü
import '../models/article_model.dart'; // Haber modeli
import '../models/category_model.dart'; // Kategori modeli
import '../pages/article_view.dart'; // Haber detay sayfası
import '../pages/all_news.dart'; // Tüm haberlerin listelendiği sayfa
import '../pages/category_news.dart'; // Kategoriye göre haber sayfası
import '../pages/login.dart'; // Giriş sayfası
import '../services/data.dart'; // Kategori verilerini döndüren fonksiyon
import '../services/news.dart'; // Haber servisleri
import '../widget/custom_app_bar.dart'; // Özel AppBar widget'ı

// ─────────────────────────────────────────────────────────────────────────────
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomePageState();
}

// ─────────────────────────────────────────────────────────────────────────────
class _HomePageState extends State<Home> {
  // Kategori listesini getiriyoruz (sabit veriler)
  final List<CategoryModel> _categories = getCategories();

  // API'den çekilecek haber listesi
  final List<ArticleModel> _articles = [];

  // Yüklenme durumu
  bool _loading = true;

  // Slider'da hangi haberin aktif olduğunu tutar
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchNews(); // Sayfa yüklendiğinde haberleri getir
  }

  // API'den haberleri çeken asenkron metod
  Future<void> _fetchNews() async {
    final newsService = News(); // Haber servisini başlat
    await newsService.getNews(); // API'den verileri al

    setState(() {
      _articles
        ..clear()
        ..addAll(newsService.news); // Gelen haberleri listeye ekle
      _loading = false; // Yüklenme tamamlandı
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Üstte özel tasarlanmış AppBar
      appBar: const CustomAppBar(),
      // Yan menü (Drawer), haber listesi parametre olarak veriliyor
      drawer: DrawerMenu(articles: _articles),
      // Sayfa içeriği: haberler yükleniyorsa yüklenme göstergesi, değilse içerik
      body:
          _loading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Yükleme durumu
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Category strip ───────────────────────────────
                    SizedBox(
                      height: 80, // Yüksekliği sabit tutulmuş yatay liste
                      child: ListView.separated(
                        padding: const EdgeInsets.only(left: 12, top: 12),
                        scrollDirection:
                            Axis.horizontal, // Yatay kaydırılabilir
                        itemCount: _categories.length,
                        itemBuilder:
                            (ctx, i) => CategoryTile(cat: _categories[i]),
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ─── Breaking header ─────────────────────────────
                    _SectionHeader(
                      title: 'Breaking News!',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AllNews(articles: _articles),
                            ),
                          ),
                    ),

                    // ─── Carousel ───────────────────────────────────
                    CarouselSlider.builder(
                      itemCount: _articles.take(10).length, // İlk 10 haber
                      itemBuilder:
                          (ctx, i, _) => _BreakingCard(article: _articles[i]),
                      options: CarouselOptions(
                        height: 220,
                        autoPlay: true,
                        enlargeCenterPage: true, // Ortadaki kartı büyüt
                        onPageChanged:
                            (i, _) => setState(
                              () => _activeIndex = i,
                            ), // Aktif index değişimi
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: _activeIndex,
                        count: _articles.length > 10 ? 10 : _articles.length,
                        effect: SlideEffect(dotHeight: 8, dotWidth: 8),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ─── Trending header ────────────────────────────
                    const _SectionHeader(title: 'Trending News!'),
                    const SizedBox(height: 10),

                    ListView.builder(
                      physics:
                          const NeverScrollableScrollPhysics(), // Scroll'u devre dışı bırak
                      shrinkWrap: true, // Sadece gerekli kadar yer kapla
                      itemCount: _articles.length,
                      itemBuilder:
                          (ctx, i) => BlogTile(
                            article: _articles[i],
                          ), // Her haber için tile
                    ),
                  ],
                ),
              ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

// Category tile
// Tek bir kategori kutucuğunu temsil eden widget
class CategoryTile extends StatelessWidget {
  final CategoryModel cat;
  const CategoryTile({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Kutucuğa tıklanınca ilgili kategori haberlerini gösteren sayfaya git
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryNews(name: cat.categoryName ?? 'General'),
            ),
          ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8), // Kenarları yumuşat
            child: CachedNetworkImage(
              imageUrl:
                  cat.image ??
                  'https://via.placeholder.com/120x70?text=${cat.categoryName}', // Resim yoksa yedek görsel
              width: 120,
              height: 70,
              fit: BoxFit.cover,
              placeholder:
                  (_, __) => const Center(
                    child: CircularProgressIndicator(),
                  ), // Yükleniyorsa göster
              errorWidget:
                  (_, __, ___) => const Icon(
                    Icons.broken_image,
                    color: Colors.white,
                  ), // Hata varsa ikon göster
            ),
          ),
          Container(
            width: 120,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.black38, // Yarı saydam siyah arka plan
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              cat.categoryName ??
                  'Category', // Kategori adı, null ise "Category"
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Breaking slider card
// Breaking News için slider'da gösterilen tek bir haber kartı
class _BreakingCard extends StatelessWidget {
  final ArticleModel article; // Gösterilecek haber verisi
  const _BreakingCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Habere tıklanınca detay sayfasına git
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArticleView(blogUrl: article.url),
            ),
          ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: article.urlToImage, // Haber görseli URL'si
              height: 220,
              width: MediaQuery.of(context).size.width, // Ekran genişliği kadar
              fit: BoxFit.cover,
              placeholder:
                  (_, __) => const Center(
                    child: CircularProgressIndicator(),
                  ), // Yükleniyorsa göster
              errorWidget:
                  (_, __, ___) => const Icon(
                    Icons.broken_image,
                    size: 64,
                    color: Colors.grey, // Hata durumunda ikon
                  ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Blog tile
// Trending News için kullanılan blog kartı widget'ı
class BlogTile extends StatelessWidget {
  final ArticleModel article; // Kartta gösterilecek haber verisi
  const BlogTile({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Kart tıklanınca detay sayfasına yönlendir
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArticleView(blogUrl: article.url),
            ),
          ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 3, // Hafif gölge efekti
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ), // Kenarları yuvarla
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                10,
              ), // Görsel köşeleri yuvarla
              child: CachedNetworkImage(
                imageUrl: article.urlToImage,
                height: 90,
                width: 90,
                fit: BoxFit.cover, // Görseli kırpmadan doldur
                placeholder:
                    (_, __) => const Center(child: CircularProgressIndicator()),
                errorWidget:
                    (_, __, ___) => const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Belirli bir bölüm başlığı gösteren widget (örneğin: "Breaking News!", "Trending News!")
// Opsiyonel olarak "View All" butonu ile sayfa geçişi yapılabilir.
class _SectionHeader extends StatelessWidget {
  final String title; // Bölüm başlığı metni
  final VoidCallback? onTap; // "View All" tıklama işlevi (isteğe bağlı)
  const _SectionHeader({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Başlık ve View All arası boşluk
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          if (onTap != null)
            GestureDetector(
              onTap: onTap, // Tıklanırsa verilen fonksiyonu çalıştır
              child: const Text(
                'View All',
                style: TextStyle(color: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }
}
