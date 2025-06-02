import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; // WebView widget'ını kullanmak için gerekli paket

class ArticleView extends StatefulWidget {
  final String blogUrl; // Detaylı haberin URL'si
  ArticleView({required this.blogUrl});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late final WebViewController
  _controller; // WebViewController, WebView'ı kontrol etmek için kullanılır

  @override
  void initState() {
    super.initState();
    // WebViewController'ı başlatıyoruz
    _controller =
        WebViewController()
          ..setJavaScriptMode(
            JavaScriptMode.unrestricted,
          ) // JavaScript kullanımına izin veriyoruz
          ..loadRequest(
            Uri.parse(widget.blogUrl),
          ); // URL'yi WebView içinde yüklüyoruz
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Başlıkları ortalıyoruz
          children: [
            const Text(
              "BT",
              style: TextStyle(color: Colors.black),
            ), // "Flutter" yazısı
            Text(
              "News",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ), // "News" yazısı
            ),
          ],
        ),
        centerTitle: true, // AppBar başlığını ortalıyoruz
        elevation: 0.0, // AppBar'ın gölgesini kaldırıyoruz
        backgroundColor: Colors.white, // AppBar'ın arka planını beyaz yapıyoruz
      ),
      body: WebViewWidget(controller: _controller),
      // WebViewWidget, verilen controller ile belirlenen URL'yi yükler
    );
  }
}
