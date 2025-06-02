import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bt_news/services/wrapper.dart';
import '../helper/shared_preferences_helper.dart';
import '../helper/sqlite_helper.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Kullanıcıdan alınacak veriler için controller'lar
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController birthPlace = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  DateTime? birthDate; // Doğum tarihi
  bool obscurePassword = true; // Şifre gizleme/gösterme durumu
  bool isLoading = false; // Yüklenme durumu (buton engelleme vs.)

  @override
  void dispose() {
    // Memory leak'i önlemek için controller'ları temizle
    email.dispose();
    password.dispose();
    birthPlace.dispose();
    city.dispose();
    firstName.dispose();
    lastName.dispose();
    super.dispose();
  }

  // Kullanıcı kayıt işlemi
  Future<void> signup() async {
    // Zorunlu alanlar boşsa uyarı göster
    if (email.text.trim().isEmpty ||
        password.text.trim().isEmpty ||
        firstName.text.trim().isEmpty ||
        lastName.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    // Yükleniyor durumunu aktif et
    setState(() {
      isLoading = true;
    });

    try {
      // Firebase Authentication ile kullanıcı oluştur
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          );

      final user = userCredential.user;
      final uid = user?.uid;

      if (uid != null) {
        // Kullanıcı bilgilerini Map olarak hazırla
        final userData = {
          "uid": uid,
          "email": email.text.trim(),
          "firstName": firstName.text.trim(),
          "lastName": lastName.text.trim(),
          "birthPlace": birthPlace.text.trim(),
          "city": city.text.trim(),
          "birthDate": birthDate?.toIso8601String(),
          "createdAt": FieldValue.serverTimestamp(), // Firestore zaman damgası
        };

        // Firestore'a kayıt
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .set(userData, SetOptions(merge: true));

        // ✅ SharedPreferences'e login state ve kullanıcı bilgilerini kaydet
        await SharedPrefsHelper.saveLoginState(true);
        await SharedPrefsHelper.saveUserInfo(
          email: email.text.trim(),
          name: firstName.text.trim(),
          surname: lastName.text.trim(),
        );

        // ✅ SQLite'e kullanıcı bilgilerini kaydet (offline erişim için)
        await SQLiteHelper.insertUser(
          email: email.text.trim(),
          name: firstName.text.trim(),
          surname: lastName.text.trim(),
          password: password.text.trim(),
        );

        // Başarılı mesaj
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration successful!"),
            backgroundColor: Colors.green,
          ),
        );

        // // Giriş sonrası yönlendirme (Ana ekrana)
        Get.offAll(() => const Wrapper());
      } else {
        throw Exception("Failed to create user.");
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseErrorMessage(e.code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      // Genel bir hata olursa yakalanır
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An unexpected error occurred: ${e.toString()}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveToSharedPreferences(
    String uid,
    Map<String, dynamic> userData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setString('email', userData['email']);
    await prefs.setString('firstName', userData['firstName']);
    await prefs.setString('lastName', userData['lastName']);
    await prefs.setString('birthPlace', userData['birthPlace']);
    await prefs.setString('city', userData['city']);

    if (birthDate != null) {
      await prefs.setString('birthDate', birthDate!.toIso8601String());
    }
  }

  // Firebase hata kodlarını kullanıcı dostu mesaja çevir
  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'email-already-in-use':
        return 'This email address is already in use.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'operation-not-allowed':
        return 'Email/password registrations are not enabled.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // Doğum tarihi seçici
  Future<void> pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        birthDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade100, Colors.green.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 40,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_add_alt_1,
                                size: 70,
                                color: Colors.green[700],
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Join Us Today!",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                              SizedBox(height: 30),
                              TextField(
                                controller: firstName,
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              TextField(
                                controller: lastName,
                                decoration: InputDecoration(
                                  labelText: 'Surname',
                                  prefixIcon: Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              TextField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              TextField(
                                controller: password,
                                obscureText: obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed:
                                        () => setState(
                                          () =>
                                              obscurePassword =
                                                  !obscurePassword,
                                        ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              TextField(
                                controller: birthPlace,
                                decoration: InputDecoration(
                                  labelText: 'Birthplace',
                                  prefixIcon: Icon(Icons.location_on),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              TextField(
                                controller: city,
                                decoration: InputDecoration(
                                  labelText: 'Province You Live In',
                                  prefixIcon: Icon(Icons.home),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              ListTile(
                                title: Text(
                                  birthDate == null
                                      ? 'Select Date of Birth'
                                      : 'Date of birth: ${birthDate!.day}.${birthDate!.month}.${birthDate!.year}',
                                ),
                                leading: Icon(Icons.cake),
                                trailing: Icon(Icons.calendar_today),
                                onTap: pickDate,
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (email.text.isEmpty ||
                                        password.text.length < 6 ||
                                        birthDate == null ||
                                        firstName.text.isEmpty ||
                                        lastName.text.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Please fill out all fields completely.",
                                          ),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                      return;
                                    }
                                    signup();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Divider(),
                              Text("Already have an account?"),
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
