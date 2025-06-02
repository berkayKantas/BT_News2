import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../pages/category_news.dart';
import '../pages/all_news.dart';
import '../pages/login.dart';
import '../pages/profileScreen.dart';
import '../pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerMenu extends StatefulWidget {
  // Tüm haber verileri Drawer üzerinden "All News" sayfasına aktarılmak için alınıyor
  final List<ArticleModel> articles;
  const DrawerMenu({super.key, required this.articles});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  String? userName; // Firestore'dan çekilecek kullanıcı adı ve soyadı
  String? userEmail; // Firestore'dan çekilecek e-posta

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Drawer ilk açıldığında kullanıcı bilgilerini getir
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser; // Oturumdaki kullanıcıyı al
    if (user == null) {
      debugPrint("User is null, not logged in!");
      return;
    }

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(); // Firestore'dan kullanıcı dökümanını getir

      if (doc.exists) {
        setState(() {
          userName = "${doc['user_name']} ${doc['user_surname']}";
          userEmail = doc['email'];
        });
      } else {
        debugPrint("No user documentation found in Firestore.");
      }
    } catch (e) {
      debugPrint("An error occurred: $e"); // Hata varsa terminale yaz
    }
  }

  // Seçilen kategoriye yönlendirme fonksiyonu
  void _navigateToCategory(BuildContext context, String categoryName) {
    Navigator.pop(context); // Drawer'ı kapat
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryNews(name: categoryName),
      ), // Kategori sayfasına yönlendir
    );
  }

  // Oturumu kapatma işlemi
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit'),
          content: const Text(
            'Are you sure you want to quit?',
          ), // Onay diyalogu
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(), // Diyalogu kapat
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                FirebaseAuth.instance.signOut(); // 🔐 Firebase oturumunu kapat
                Navigator.of(context).pop(); // Diyalogu kapat
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Login(),
                  ), // Login ekranına yönlendir
                  (route) => false, // Önceki tüm sayfaları kaldır
                );
                // Oturum kapatıldı mesajı göster
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Exit done')));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Drawer başlığı: Kullanıcı adı ve e-posta gösterilir
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            accountName: Text(
              userName ?? 'Loading...',
            ), // İsim yoksa "Loading..." göster
            accountEmail: Text(userEmail ?? ''),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage(
                'images/avatar.jpg',
              ), // Varsayılan profil resmi
            ),
          ),
          // Ana Sayfa yönlendirme
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Home()),
              );
            },
          ),
          // Tüm Haberler sayfasına yönlendirme
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('All News'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AllNews(articles: widget.articles),
                ),
              );
            },
          ),
          // Kategori yönlendirmeleri
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Business'),
            onTap: () => _navigateToCategory(context, 'Business'),
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Entertainment'),
            onTap: () => _navigateToCategory(context, 'Entertainment'),
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('General'),
            onTap: () => _navigateToCategory(context, 'General'),
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text('Health'),
            onTap: () => _navigateToCategory(context, 'Health'),
          ),
          ListTile(
            leading: const Icon(Icons.sports),
            title: const Text('Sports'),
            onTap: () => _navigateToCategory(context, 'Sports'),
          ),
          const Divider(),
          // Profil sayfasına yönlendirme
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          // Oturum kapatma seçeneği
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Log Out'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
