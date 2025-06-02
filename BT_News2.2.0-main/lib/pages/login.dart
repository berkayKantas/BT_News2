import 'dart:convert';
import 'package:flutter/foundation.dart'; // kIsWeb için
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bt_news/services/wrapper.dart';
import '../helper/shared_preferences_helper.dart';
import '../helper/sqlite_helper.dart';

class UserDatabase {
  static Database? _database;
  // Veritabanı bağlantısını açar veya mevcutsa döner
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    final path = join(await getDatabasesPath(), 'user.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // user tablosunu oluşturur
        await db.execute('CREATE TABLE user(id TEXT PRIMARY KEY, email TEXT)');
      },
    );
    return _database!;
  }

  // Kullanıcı verisini veritabanına ekler veya günceller
  static Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await getDatabase();
    await db.insert('user', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

// SharedPreferences'da giriş durumunu kaydeder
Future<void> saveLoginState(bool loggedIn) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('loggedIn', loggedIn);
}

// SharedPreferences'dan giriş durumunu okur
Future<bool> getLoginState() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('loggedIn') ?? false;
}

// Firestore'dan kullanıcı profilini çeker (mobil için)
Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
  try {
    // Web platformunda Firestore erişimini kontrol et
    if (kIsWeb) {
      // Web için alternatif yöntem veya sadece null döndür
      debugPrint("Bypassing Firestore access on the web platform");
      return null;
    }

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data();
    }
  } catch (e) {
    debugPrint("Firestore fetch error: $e");
  }
  return null;
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  bool isLoading = false;

  // Hesap zaten var hatasıyla karşılaşılırsa kullanıcıyı bilgilendirir ve yönlendirir
  Future<void> _handleAccountExistsError(FirebaseAuthException e) async {
    try {
      // Email adresini al
      final email = e.email;
      if (email == null) {
        Get.snackbar(
          "Error",
          "Email address could not be retrieved.",
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
        return;
      }

      // Email ile kayıtlı giriş yöntemlerini alır
      final signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email);

      if (signInMethods.isEmpty) {
        // Hesap yoksa yeni hesap oluşturmayı başlatır
        Get.snackbar(
          "Information",
          "A new account is being created with this email...",
          backgroundColor: Colors.blue.shade700,
          colorText: Colors.white,
        );
        await _createNewAccountWithProvider(e);
        return;
      }

      // Kullanıcıya mevcut giriş yöntemlerini gösterir
      String providers = signInMethods
          .map((method) {
            switch (method) {
              case 'password':
                return 'Email/Password';
              case 'google.com':
                return 'Google';
              case 'github.com':
                return 'GitHub';
              default:
                return method;
            }
          })
          .join(', ');

      Get.snackbar(
        "Account Already Exists",
        "There is already an account with this email address. Please log in using one of the following methods: $providers",
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      // Eğer sadece password varsa, kullanıcıyı email ile giriş yapmaya yönlendir
      if (signInMethods.contains('password') && signInMethods.length == 1) {
        emailController.text = email;
        Get.snackbar(
          "Information",
          "Your email address has been automatically filled in. Please enter your password.",
          backgroundColor: Colors.blue.shade700,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      Get.snackbar(
        "Error",
        "An error occurred while checking account information: $error",
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }
  }

  // Yeni hesap oluşturma ve OAuth sağlayıcısını bağlama işlemi
  Future<void> _createNewAccountWithProvider(
    FirebaseAuthException originalError,
  ) async {
    try {
      // Orijinal credential'ı al
      final credential = originalError.credential;
      final email = originalError.email;

      if (credential == null || email == null) {
        Get.snackbar(
          "Error",
          "The information required to create an account is missing.",
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
        return;
      }

      // Yeni hesap oluştur ve provider'ı bağla
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      // Firestore'a kullanıcı bilgilerini kaydet
      if (userCredential.user != null) {
        final user = userCredential.user!;

        // Web için Firestore'a kaydetmeyi dene, hata olursa sessizce geç
        if (!kIsWeb) {
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
                  'email': user.email ?? email,
                  'displayName': user.displayName ?? '',
                  'photoURL': user.photoURL ?? '',
                  'createdAt': FieldValue.serverTimestamp(),
                });
          } catch (e) {
            debugPrint("Firestore write error: $e");
          }
        }

        // Local database ve SharedPreferences'a kaydet
        if (kIsWeb) {
          await saveLoginState(true);
        } else {
          await UserDatabase.insertUser({
            'id': user.uid,
            'email': user.email ?? email,
          });
          await saveLoginState(true);
        }

        Get.snackbar(
          "Successful",
          "Your account has been successfully created and you are logged in!",
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
        );

        Get.offAll(() => const Wrapper());
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while creating the account: $e",
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }
  }

  // Email/Şifre ile giriş işlemi
  Future<void> loginWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.length < 6) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address and a password of at least 6 characters.",
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
      return;
    }

    try {
      setState(() => isLoading = true);
      // Firebase Auth ile giriş yapar
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;
      if (uid != null) {
        // Kullanıcı profilini Firestore'dan çeker
        final profile = await fetchUserProfile(uid);

        // Web ve mobil için farklı yaklaşım
        if (kIsWeb) {
          // Web için SharedPreferences kullan
          await saveLoginState(true);
        } else {
          // Mobil için SQLite kullan
          if (profile != null) {
            await UserDatabase.insertUser({
              'id': uid,
              'email': profile['email'] ?? email,
            });
          } else {
            await UserDatabase.insertUser({'id': uid, 'email': email});
          }
          await saveLoginState(true);
        }
      }
      // Giriş sonrası Wrapper sayfasına yönlendirir
      Get.offAll(() => const Wrapper());
    } on FirebaseAuthException catch (e) {
      // Hata mesajı gösterir
      Get.snackbar(
        "Login Failed",
        e.message ?? "An unknown error occurred.",
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Google ile giriş işlemi
  Future<void> loginWithGoogle() async {
    try {
      setState(() => isLoading = true);

      AuthCredential? credential;

      if (kIsWeb) {
        // Web için Google signInWithPopup kullanır
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // Mobilde GoogleSignIn paketi ile giriş yapar
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final googleAuth = await googleUser.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      final uid = FirebaseAuth.instance.currentUser?.uid;
      final email = FirebaseAuth.instance.currentUser?.email ?? "";

      if (uid != null) {
        final profile = await fetchUserProfile(uid);

        // Web ve mobil için farklı yaklaşım
        if (kIsWeb) {
          // Web için SharedPreferences kullan
          await saveLoginState(true);
        } else {
          // Mobil için SQLite kullan
          if (profile != null) {
            await UserDatabase.insertUser({
              'id': uid,
              'email': profile['email'] ?? email,
            });
          } else {
            await UserDatabase.insertUser({'id': uid, 'email': email});
          }
          await saveLoginState(true);
        }
      }

      Get.offAll(() => const Wrapper());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        await _handleAccountExistsError(e);
      } else {
        Get.snackbar(
          "Google Login Failed",
          e.message ?? "An unknown error occurred.",
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Google Login Failed",
        e.toString(),
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // GitHub ile giriş işlemi
  Future<void> loginWithGitHub() async {
    try {
      setState(() => isLoading = true);

      if (kIsWeb) {
        // Web için Firebase Auth GitHub Provider kullan
        GithubAuthProvider githubProvider = GithubAuthProvider();
        githubProvider.addScope('read:user');
        githubProvider.addScope('user:email');

        await FirebaseAuth.instance.signInWithPopup(githubProvider);
      } else {
        // Mobil için OAuth flow kullan
        const clientId = "Ov23li9FVHJG6lKBHgte";
        const clientSecret = "987d0f0a5c425a879113ad8ffdca8a37a0a1ac75";
        const redirectUri =
            "https://newsapplogin-8e4d1.firebaseapp.com/__/auth/handler";

        final authUrl = Uri.https("github.com", "/login/oauth/authorize", {
          "client_id": clientId,
          "redirect_uri": redirectUri,
          "scope": "read:user user:email",
        });

        final result = await FlutterWebAuth2.authenticate(
          url: authUrl.toString(),
          callbackUrlScheme: "https",
        );

        final code = Uri.parse(result).queryParameters["code"];
        if (code == null) throw Exception("Could not get code");

        final tokenResponse = await http.post(
          Uri.parse("https://github.com/login/oauth/access_token"),
          headers: {"Accept": "application/json"},
          body: {
            "client_id": clientId,
            "client_secret": clientSecret,
            "code": code,
            "redirect_uri": redirectUri,
          },
        );

        final tokenJson = json.decode(tokenResponse.body);
        final accessToken = tokenJson["access_token"];
        if (accessToken == null)
          throw Exception("Access token could not be obtained");

        final credential = GithubAuthProvider.credential(accessToken);
        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      final uid = FirebaseAuth.instance.currentUser?.uid;
      final email = FirebaseAuth.instance.currentUser?.email ?? "";

      if (uid != null) {
        final profile = await fetchUserProfile(uid);

        if (kIsWeb) {
          await saveLoginState(true);
        } else {
          if (profile != null) {
            await UserDatabase.insertUser({
              'id': uid,
              'email': profile['email'] ?? email,
            });
          } else {
            await UserDatabase.insertUser({'id': uid, 'email': email});
          }
          await saveLoginState(true);
        }
      }

      Get.offAll(() => const Wrapper());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        await _handleAccountExistsError(e);
      } else {
        Get.snackbar(
          "GitHub Login Failed",
          e.message ?? "An unknown error occurred.",
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "GitHub Login Failed",
        e.toString(),
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      // İşlem tamamlandığında yüklenme durumunu false yaparak UI'ı güncelle
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            shadowColor: Colors.blue.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 72,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Welcome Back!",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please login to your account",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.black),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue,
                        ),
                        onPressed:
                            () => setState(
                              () => obscurePassword = !obscurePassword,
                            ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.blue)
                      : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: loginWithEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text("Login"),
                        ),
                      ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.blue.shade100,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "OR",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.blueGrey.shade400,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.blue.shade100,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : loginWithGoogle,
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: const Text("Continue with Google"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : loginWithGitHub,
                      icon: const Icon(Icons.code, color: Colors.white),
                      label: const Text("Continue with GitHub"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.blueGrey.shade700),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed('/signup'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed('/forgot-password'),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
