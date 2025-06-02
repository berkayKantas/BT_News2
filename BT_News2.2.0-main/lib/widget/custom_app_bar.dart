import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Uygulamaya özel AppBar widget'ı.
// StatelessWidget ve PreferredSizeWidget implementasyonu ile,
// AppBar'ın yüksekliği belirlenir.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white, // Arka plan beyaz yapıldı
      elevation: 0, // Gölgelendirme kaldırıldı, daha düz görünüm
      centerTitle: true, // Başlık ortalanacak
      iconTheme: const IconThemeData(color: Colors.black),

      // Drawer menü ikonlarının siyah renkte görünmesini sağlar
      title: RichText(
        // Farklı renk ve stillerde yazı parçaları için RichText kullanıldı
        text: const TextSpan(
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: 'BT',
              style: TextStyle(color: Colors.black),
            ), // Siyah renkli 'BT'
            TextSpan(
              text: 'News',
              style: TextStyle(color: Colors.blue),
            ), // Mavi renkli 'News'
          ],
        ),
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: 12.0,
          ), // Sağ tarafa boşluk bırakıldı
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/settings'),
            // Ayarlar sayfasına yönlendirme
            child: Image.asset('images/logo.png', height: 30),
            // Sağ üstte logo görüntüsü (buton gibi)
          ),
        ),
      ],
    );
  }

  // AppBar yüksekliği sabit olarak kToolbarHeight (56.0) veriliyor
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
