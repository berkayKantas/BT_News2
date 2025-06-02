import 'dart:convert'; // JSON verilerini işlemek için kullanılan paket
import 'package:bt_news/models/slider_model.dart'; // sliderModel sınıfını import ediyoruz
import 'package:http/http.dart'
    as http; // HTTP istekleri yapmak için http paketini import ediyoruz

class Slider {
  List<SliderModel> sliders = [];
  // Slider haberlerini çekmek için asenkron fonksiyon
  Future<void> getSlider() async {
    // API'ye yapılacak istek için URL oluşturuluyor. TechCrunch kaynağından veriler alınıyor
    String url =
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=8ca749c4e11d4b70a9562dc36918717a";

    // HTTP GET isteği gönderiliyor
    var response = await http.get(Uri.parse(url));

    // API'den gelen JSON yanıtı çözümleniyor
    var jsonData = jsonDecode(response.body);

    // Eğer API cevabı "ok" ise, yani veri düzgün geldiyse
    if (jsonData['status'] == 'ok') {
      // API cevabındaki "articles" verisini döngüye alıyoruz
      jsonData["articles"].forEach((element) {
        // Görsel (urlToImage) ve açıklama (description) varsa, veri geçerli kabul ediliyor
        if (element["urlToImage"] != null && element['description'] != null) {
          // sliderModel nesnesi oluşturuluyor ve veriyi bu nesneye ekliyoruz
          SliderModel slidermodel = SliderModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );

          // Oluşturduğumuz slider nesnesini listeye ekliyoruz
          sliders.add(slidermodel);
        }
      });
    }
  }
}
