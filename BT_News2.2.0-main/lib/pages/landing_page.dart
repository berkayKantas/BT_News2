import 'package:flutter/material.dart';
import 'home.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // ⬅️ çentik‑ekranlarda içerik taşmasın
        child: SingleChildScrollView(
          // ⬅️ dikeyde kaydırılabilir hâle getir
          padding: const EdgeInsets.all(10), // önceki margin yerine padding
          child: Column(
            children: [
              // — Foto —
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(30),
                clipBehavior:
                    Clip.antiAlias, // ClipRRect kullanmaya gerek kalmadı
                child: Image.asset(
                  'images/building.jpg',
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.7,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // — Başlık —
              const Text(
                'News from around the \nworld for you',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // — Açıklama —
              const Text(
                'Best time to read, take your time to read\n'
                'a little more of this world',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // — Get Started butonu —
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Home()),
                    ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
