import 'package:firebase_auth/firebase_auth.dart';
// Firebase Authentication'ı kullanabilmek için import ediliyor
import 'package:flutter/material.dart'; // Flutter UI elementlerini kullanmak için import ediliyor
import 'package:bt_news/pages/landing_page.dart'; // Kullanıcı giriş yaptıysa yönlendirilecek ana sayfa
import 'package:bt_news/pages/login.dart'; // Kullanıcı giriş yapmamışsa gösterilecek giriş sayfası

// Wrapper widget'ı, giriş durumu ve yönlendirmeyi yönetir
class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // FirebaseAuth üzerinden kullanıcı oturum durumunu dinleyen bir StreamBuilder kullanıyoruz
        stream:
            FirebaseAuth.instance
                .authStateChanges(), // Firebase Auth ile oturum değişikliklerini takip ediyoruz
        builder: (context, snapshot) {
          // Eğer snapshot verisi mevcutsa, yani kullanıcı giriş yapmışsa
          if (snapshot.hasData) {
            return LandingPage(); // Kullanıcı giriş yaptıysa, ana sayfaya yönlendiriyoruz
          }
          // Kullanıcı giriş yapmamışsa, Login sayfasına yönlendiriyoruz
          else {
            return Login(); // Kullanıcı giriş yapmamışsa, login sayfasını gösteriyoruz
          }
        },
      ),
    );
  }
}
