import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widget/BasePage.dart';

// Kullanıcı profil bilgilerini görüntüleme ve düzenleme ekranı
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>(); // Form doğrulama anahtarı

  // ── Kullanıcı bilgilerini tutan controller'lar ──
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final birthplaceController = TextEditingController();
  final nowProvinceController = TextEditingController();
  final birthdayController = TextEditingController();

  bool _isLoading = false; // Yüklenme durumu göstergesi

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Sayfa yüklendiğinde kullanıcı verilerini çek
  }

  // Kullanıcı profil verilerini Supabase'ten yükle
  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Kullanıcı oturum açmamışsa uyarı göster
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User is not logged in.')),
          );
        }
        return;
      }

      final uid = user.uid;
      print('User UID: $uid');
      // Supabase'ten kullanıcı verisini çek
      final response =
          await Supabase.instance.client
              .from('users')
              .select('*')
              .eq('user_id', uid)
              .maybeSingle();

      print('Supabase response: $response');

      if (response != null) {
        // Controller'lara gelen veriyi yerleştir
        nameController.text = response['user_name']?.toString() ?? '';
        surnameController.text = response['user_surname']?.toString() ?? '';
        birthplaceController.text = response['birthplace']?.toString() ?? '';
        nowProvinceController.text = response['nowprovince']?.toString() ?? '';
        birthdayController.text = response['birthday']?.toString() ?? '';

        print('Profile data loaded successfully');
      } else {
        // Kullanıcıya ait veri yoksa boş profil oluştur
        print('No user profile found in Supabase');
        await _createEmptyProfile(uid);
      }
    } catch (e) {
      print('Error loading profile data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile information: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Kullanıcı için Supabase'te boş profil oluşturur
  Future<void> _createEmptyProfile(String uid) async {
    try {
      await Supabase.instance.client.from('users').insert({
        'user_id': uid,
        'user_name': '',
        'user_surname': '',
        'birthplace': '',
        'nowprovince': '',
        'birthday': '',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      print('Empty profile created for new user');
    } catch (e) {
      print('Error creating empty profile: $e');
    }
  }

  // Form geçerliyse kullanıcı bilgilerini günceller veya ekler
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User is not logged in');
      }

      final uid = user.uid;
      print('Updating profile for UID: $uid');
      // Supabase'te kullanıcı kaydı var mı kontrol et
      final existingRecord =
          await Supabase.instance.client
              .from('users')
              .select('user_id')
              .eq('user_id', uid)
              .maybeSingle();

      print('Existing record check: $existingRecord');

      final updateData = {
        'user_id': uid,
        'user_name': nameController.text.trim(),
        'user_surname': surnameController.text.trim(),
        'birthplace': birthplaceController.text.trim(),
        'nowprovince': nowProvinceController.text.trim(),
        'birthday': birthdayController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      print('Update data: $updateData');
      // Kayıt varsa güncelle, yoksa oluştur
      if (existingRecord != null) {
        await Supabase.instance.client
            .from('users')
            .update(updateData)
            .eq('user_id', uid);
        print('Profile updated successfully');
      } else {
        await Supabase.instance.client.from('users').insert(updateData);
        print('Profile created successfully');
      }
      // Başarılı bildirim
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile information has been updated successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Update error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Tek bir form alanı oluşturan yardımcı metod
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    String? hintText,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon:
              icon != null
                  ? Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: Colors.blue.shade600, size: 20),
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        ),
        validator:
            (value) =>
                value == null || value.trim().isEmpty
                    ? '$label cannot be left blank'
                    : null,
        enabled: !_isLoading,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Profil',
      contentWidget: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade50, Colors.white],
          ),
        ),
        child:
            _isLoading
                ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading...',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: [
                      // Header Section
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade600,
                              Colors.blue.shade800,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.account_circle,
                              size: 64,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Profile Information',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'You can update your personal information',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Form Section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.person_outline,
                                        color: Colors.blue.shade600,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Personal Information',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                _buildTextField(
                                  nameController,
                                  'Name',
                                  hintText: 'Enter your name',
                                  icon: Icons.badge_outlined,
                                ),
                                _buildTextField(
                                  surnameController,
                                  'Surname',
                                  hintText: 'Enter your surname',
                                  icon: Icons.badge_outlined,
                                ),
                                _buildTextField(
                                  birthplaceController,
                                  'Birthplace',
                                  hintText: 'Enter your city of birth',
                                  icon: Icons.location_city_outlined,
                                ),
                                _buildTextField(
                                  nowProvinceController,
                                  'Province of Residence',
                                  hintText:
                                      'Enter the city you currently live in',
                                  icon: Icons.location_on_outlined,
                                ),
                                _buildTextField(
                                  birthdayController,
                                  'Date of birth',
                                  hintText: 'dd.mm.yyyy in format',
                                  keyboardType: TextInputType.datetime,
                                  icon: Icons.calendar_today_outlined,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Update Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.blue.shade600,
                              Colors.blue.shade700,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save_outlined, size: 20),
                          label: const Text(
                            'Update Profile Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: _isLoading ? null : _updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
      articles: [],
    );
  }

  @override
  void dispose() {
    // Sayfa yok edilirken her bir TextEditingController'ı bellekten temizle
    nameController.dispose();
    surnameController.dispose();
    birthplaceController.dispose();
    nowProvinceController.dispose();
    birthdayController.dispose();
    // Üst sınıfın dispose metodunu da çağırarak temizlik işlemini tamamla
    super.dispose();
  }
}
