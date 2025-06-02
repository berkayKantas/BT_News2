import 'package:flutter/material.dart';
import 'custom_app_bar.dart'; // Uygulamaya özel AppBar widget'ı
import 'drawer_menu.dart'; // Drawer menüsünü içeren widget

import '../models/article_model.dart'; // Haber modeli

// ─────────────────────────────────────────────────────────────────────────────
// Uygulamanın temel sayfa yapısıdır.
// Tüm sayfalar bu sınıfı kullanarak ortak AppBar ve Drawer yapısına sahip olabilir.
class BasePage extends StatelessWidget {
  final String
  title; // Sayfa başlığı (şu an kullanılmıyor, ileride kullanılabilir)
  final Widget contentWidget; // Sayfanın ana içeriğini temsil eden widget
  final List<ArticleModel> articles; // Drawer için gönderilen haber listesi

  const BasePage({
    super.key,
    required this.title,
    required this.contentWidget,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Özel app bar kullanılıyor
      drawer: DrawerMenu(
        articles: articles, // Drawer içine haber listesi aktarılıyor
      ),
      body: contentWidget, // Sayfanın ana içeriği burada gösteriliyor
    );
  }
}
