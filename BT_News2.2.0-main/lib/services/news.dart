// lib/services/news.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class News {
  final List<ArticleModel> news = [];

  Future<void> getNews() async {
    // 30 gün önceki tarih
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final from =
        '${thirtyDaysAgo.year}-${thirtyDaysAgo.month.toString().padLeft(2, '0')}-${thirtyDaysAgo.day.toString().padLeft(2, '0')}';

    // URL’yi Uri ile oluştur
    final uri = Uri.https('newsapi.org', '/v2/everything', {
      'q': 'tesla',
      'from': from,
      'sortBy': 'publishedAt',
      'apiKey': '8ca749c4e11d4b70a9562dc36918717a',
    });

    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('News API ‑ ${res.statusCode}');

    final data = jsonDecode(res.body);
    if (data['status'] != 'ok') return;

    news
      ..clear() // 🔹 eskiyi temizle
      ..addAll(
        (data['articles'] as List)
            .map((e) => ArticleModel.fromJson(e))
            .toList(),
      );
  }
}
