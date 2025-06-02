// lib/services/show_category_news.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/show_category.dart'; // doğru yol

class ShowCategoryNews {
  final List<ShowCategoryModel> categories = [];
  final _key = '8ca749c4e11d4b70a9562dc36918717a';

  /// Seçilen kategoriye ait manşetleri çeker
  Future<void> getCategoriesNews(String category) async {
    final uri = Uri.https('newsapi.org', '/v2/top-headlines', {
      'country': 'us',
      'category': category,
      'apiKey': _key,
    });

    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('NewsAPI – ${res.statusCode}');

    final data = jsonDecode(res.body);
    if (data['status'] != 'ok') return;

    categories
      ..clear()
      ..addAll(
        (data['articles'] as List)
            .map((e) => ShowCategoryModel.fromJson(e))
            .toList(),
      );
  }
}
