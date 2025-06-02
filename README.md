# 📰 Mobil Uygulama Geliştirme - BTNews (API Kullanarak Haber Uygulaması)

# 🎯 Proje Amacı

Bu proje, mobil uygulama geliştirme dersi kapsamında kullanıcıların güncel haberlere ulaşabileceği bir mobil uygulama geliştirmek amacıyla yapılmıştır. Uygulama içerisinde kullanılan veriler bir haber API’sinden çekilmekte olup, haber başlıkları ve görseller dinamik olarak görüntülenmektedir. Kullanıcı bir habere tıkladığında, doğrudan haberin yayınlandığı **orijinal web sitesine** yönlendirilir.

---

# ⚙️ Teknik Detaylar ve Öne Çıkan Özellikler

- Flutter SDK ile geliştirilmiştir.
- Haberler ve görseller **NewsAPI** üzerinden çekilmektedir.
- Giriş sistemi için **Firebase Authentication** kullanılmıştır.
- Drawer menü kullanılarak uygulama içinde kolay gezinme sağlanmıştır.
- Dinamik API verisi ile sürekli güncellenen içerik yapısı mevcuttur.
- Kullanıcılar haber detayına tıklayarak orijinal kaynağa yönlendirilir.
- Responsive tasarımı sayesinde tüm cihaz boyutlarında uyumlu çalışır.
  
---

# 📄 Uygulama Sayfaları ve Görevleri
### 1. **LandingPage Sayfası**

- **Görev**: Kullanıcıyı karşılayan açılış sayfasıdır. Bu sayfa, kullanıcının uygulamaya giriş yapmadan önce gördüğü ilk ekran olup, uygulamanın amacını ve içeriğini tanıtır.
  
- **İçerikler**:
  - **Görsel Başlık**: Sayfada büyük bir başlık yer alır: `"News from around the world for you"`. Bu başlık, kullanıcılara dünya çapındaki haberleri sunduğumuzu vurgular.
  - **Açıklama Metni**: Başlığın altında, `"Best time to read, take your time to read a little more of this world"` şeklinde bir açıklama metni bulunur. Bu metin, kullanıcıyı haber okumaya teşvik eder.
  - **Ana Sayfaya Yönlendiren Buton**: Kullanıcıyı uygulamanın ana sayfasına yönlendiren "Get Started" butonu bulunur. Bu butona tıklayarak kullanıcı, uygulamanın ana sayfasına geçiş yapar.
  - **Navigasyon**: Butona tıklanıldığında, kullanıcıyı `Home` sayfasına yönlendiren bir yönlendirme yapılır. `Navigator.push` kullanılarak geçiş sağlanır.

- **Tasarım**:
  - Sayfa, görsel bir öğe (binanın fotoğrafı) ile başlar ve kullanıcıyı uygulamanın ne sunduğunu anlatan açıklamalarla devam eder.
  - Buton, mavi renk ile dikkat çekici hale getirilmiş ve yuvarlatılmış köşelere sahip bir şekilde tasarlanmıştır.
  - `GestureDetector` widget'ı ile buton tıklanabilir hale getirilmiş, kullanıcı etkileşime girebilir.

- **Kullanılan Widget'lar**:
  - `Scaffold`: Temel yapı için kullanılır.
  - `Column`: Dikey düzen için kullanılır.
  - `Material`: Butonun stilini ve gölgelendirmesini sağlamak için kullanılır.
  - `GestureDetector`: Buton tıklanabilir hale getirilir.
  - `SizedBox`: Öğeler arasına boşluk eklemek için kullanılır.
  - `Image.asset`: Uygulama görseli ekler.

Bu sayfa, kullanıcıyı uygulamaya davet eden ve onları ana sayfaya yönlendiren basit ancak etkili bir açılış ekranıdır.

  
![Image](https://github.com/user-attachments/assets/e3daa07b-d195-418a-aa26-15c439f37d85)

### 2. **Login Sayfası**

#### 🧩 Görev
Kullanıcıların e-posta ve şifre ile giriş yapmasını sağlar.

- ✅ Başarılı girişte kullanıcı `LandingPage` sayfasına yönlendirilir.
- ❌ Hatalı girişlerde Firebase Authentication'dan alınan hata mesajları `Get.snackbar()` ile gösterilir.
- 🔐 "Forgot Password?" bağlantısı ile şifre sıfırlama ekranına yönlendirme yapılır.
- 📝 "Sign Up" bağlantısı ile kullanıcı kayıt ekranına geçiş sağlanır.
- 🌐 Google ve GitHub ile alternatif giriş yöntemleri sunulur.

---

#### 🧱 İçerikler ve Fonksiyonlar

- **Başlık ve Alt Başlık**
  - Sayfa, büyük bir `lock` ikonu ile başlar.
  - `Welcome Back!` başlığı ve `Please login to your account` açıklaması içerir.

- **E-posta Girişi**
  - `TextField` aracılığıyla e-posta girişi yapılır.
  - `Icons.email_outlined` ikonu kullanılır.

- **Şifre Girişi**
  - Şifre girişi `obscureText` ile gizlenir.
  - Göz ikonu ile şifre göster/gizle kontrolü yapılabilir.
  - `Icons.lock_outline` ikonu kullanılır.

- **Giriş Butonu**
  - `ElevatedButton` ile stilize edilmiştir.
  - Butona tıklanınca `loginWithEmail()` fonksiyonu tetiklenir.
  - Giriş sırasında `CircularProgressIndicator` gösterilir.

- **Google ile Giriş**
  - `ElevatedButton.icon` ile Google simgesi eşliğinde buton sunulur.
  - `loginWithGoogle()` fonksiyonu çalıştırılır.

- **GitHub ile Giriş**
  - `Icons.code` ikonu ile temsil edilir.
  - `loginWithGitHub()` fonksiyonu çağrılır.

- **Kayıt Olma Bağlantısı**
  - “Don’t have an account?” metni ile birlikte `Sign Up` linki sunulur.
  - `Get.toNamed('/signup')` yönlendirmesi yapılır.

- **Şifre Sıfırlama**
  - “Forgot Password?” bağlantısı bir `TextButton` olarak sunulur.
  - `Get.toNamed('/forgot-password')` ile yönlendirme yapılır.

---

#### 🎨 Tasarım

- Arka plan rengi `Colors.blue.shade50` ile açık mavi tonlarında sade bir görünüm sağlar.
- Sayfa içeriği `Card` widget’ı ile çerçevelenmiştir. Köşeler `borderRadius` ile yuvarlatılmıştır.
- Butonlar mavi tonlarda tasarlanmıştır.
- Sayfa `SingleChildScrollView` ile kaydırılabilir yapılmıştır.
- Sosyal girişler ile form, `Divider` widget’ı ile görsel olarak ayrılmıştır.

---

#### 🧠 Kullanıcı Deneyimi (UX)

- `Get.toNamed()` ile yönlendirmeler hızlı ve animasyonludur.
- Giriş işlemi süresince `isLoading` değişkeni ile yüklenme durumu kontrol edilir.
- Hatalı girişlerde `Get.snackbar()` ile hata mesajları kullanıcıya gösterilir.
- Şifre gösterme/gizleme özelliği kullanıcıya kontrol sunar.

---

#### 🧩 Kullanılan Widget’lar

| Widget                     | Amaç                                                |
|----------------------------|-----------------------------------------------------|
| `Scaffold`                 | Sayfanın temel yapısını oluşturur                   |
| `Card`                     | Giriş kutusunu stilize etmek için kullanılır        |
| `TextField`                | E-posta ve şifre girişi                             |
| `ElevatedButton`           | Giriş ve sosyal medya butonları                     |
| `TextButton`               | Şifre sıfırlama ve kayıt linkleri                   |
| `Divider`                  | "OR" bölümü görsel olarak ayırır                    |
| `Icon`                     | Giriş alanlarını tanımlayan ikonlar                 |
| `CircularProgressIndicator`| Giriş sırasında yüklenme animasyonu                 |
| `Get.snackbar()`           | Hata mesajlarını kullanıcıya göstermek için         |
| `Get.toNamed()`            | Sayfalar arası geçişleri dinamik olarak yönetmek    |

---

Bu sayfa, kullanıcıların uygulamaya güvenli ve kolay bir şekilde giriş yapmasını sağlayan, modern tasarıma sahip temel bir ekrandır.


![Image](https://github.com/user-attachments/assets/d581ca9c-032c-4a48-bf13-f286eb545789)

## 📝 3. **Signup Sayfası**

**Görev:**  
Kullanıcıların geçerli bir e-posta ve en az 6 karakter uzunluğunda bir şifreyle yeni hesap oluşturmalarını sağlar.

---

### ✅ Özellikler

- Firebase Authentication ile kullanıcı kaydı yapılır.
- Başarılı kayıt sonrası kullanıcı `Wrapper` sayfasına yönlendirilir.
- Geçersiz e-posta veya kısa şifre girişinde kullanıcı `SnackBar` ile bilgilendirilir.
- "Login" butonuna tıklanarak giriş sayfasına geri dönülebilir.

---

### 📄 İçerikler

- **Başlık:**  
  **Join Us Today!**  
  _Create an account to access the latest news and updates._

- **E-posta Girişi:**  
  `TextField` ile kullanıcıdan geçerli bir e-posta adresi alınır.

- **Şifre Girişi:**  
  - `TextField` şifreyi `obscureText` ile gizler.  
  - Şifre görünürlüğü bir ikon ile kontrol edilebilir.

- **Kayıt Butonu:**  
  Gerekli alanlar doldurulduğunda `Sign Up` butonuna tıklanarak hesap oluşturulur.

- **Giriş Linki:**  
  “Already have an account?” ifadesinin yanında yer alan `Login` butonuyla giriş sayfasına geçiş yapılır.

---

### 🎨 Tasarım Detayları

- Arka plan `LinearGradient` ile yeşil tonlarda oluşturulmuştur.
- Sayfa içeriği, yuvarlatılmış köşelere sahip bir `Card` widget'ı ile sunulmuştur.
- `ElevatedButton`, `TextButton`, `Divider` gibi bileşenler sayfa estetiğini artırmak için kullanılmıştır.

---

### 🧠 Kullanıcı Deneyimi (UX)

- `SnackBar` ile eksik veya hatalı girişlerde kullanıcı bilgilendirilir.
- `Get.back()` ile kullanıcı bir önceki sayfaya dönebilir.
- Tüm form alanlarında kullanıcı dostu geri bildirimler sağlanır.

---

### 🧱 Kullanılan Widget'lar

| Widget            | Açıklama                                                  |
|--------------------|-------------------------------------------------------------|
| `Scaffold`         | Sayfa yapısını oluşturur                                   |
| `TextField`        | E-posta ve şifre giriş alanları                            |
| `ElevatedButton`   | Kayıt işlemi butonu                                        |
| `TextButton`       | Giriş sayfasına yönlendirme bağlantısı                     |
| `SnackBar`         | Hata ve uyarı mesajları                                    |
| `Icon`             | Şifre görünürlüğü ve dekoratif ikonlar                     |
| `Card`             | Sayfa içeriğini şık bir şekilde sunmak için kullanılır     |
| `Divider`          | Sayfa bölümlerini ayırmak için görsel ayrım sağlar         |

---

![Image](https://github.com/user-attachments/assets/72a0b296-a6c8-4868-9d82-b0e304ec38c4)


### 4. **Forgot Password Sayfası**

- **Görev**: Kullanıcının şifresini unuttuğu durumda, e-posta adresi girerek şifre sıfırlama bağlantısı almasını sağlar.
  - Kullanıcı, e-posta adresini girip **"Send Reset Link"** butonuna tıkladığında, **Firebase Authentication** servisi aracılığıyla şifre sıfırlama bağlantısı gönderilir.
  - İşlem tamamlandığında, kullanıcıya bir onay mesajı (SnackBar) gösterilir.
  - Şifre sıfırlama işlemi için kullanıcının geçerli bir e-posta adresi girmesi gerekir.
  - Kullanıcı, şifre sıfırlama işlemi tamamlandıktan sonra **Login** sayfasına geri dönebilir.

- **İçerikler**:
  - **Başlık**: Sayfa, kullanıcıya `"Forgot Password?"` başlığı ile karşılar. Altında `"Enter your email to receive a reset link."` şeklinde açıklama yer alır.
  - **E-posta Girişi**: Kullanıcıdan şifre sıfırlama için geçerli bir e-posta adresi girmesi istenir. **TextField** widget'ı ile alınır.
  - **Şifre Sıfırlama Butonu**: Kullanıcı, geçerli e-posta adresini girip **"Send Reset Link"** butonuna tıkladığında şifre sıfırlama bağlantısı gönderilir.
  - **Geri Dönüş Linki**: Kullanıcı, şifre sıfırlama işlemi sonrası giriş ekranına geri dönmek için **"Back to Login"** butonuna tıklayarak giriş ekranına yönlendirilir.

- **Tasarım**:
  - Sayfa, **LinearGradient** ile mor tonlarda bir arka plan gradienti ile tasarlanmıştır.
  - Sayfa içeriği **Card** widget'ı ile şekillendirilmiş ve kenarlarda yuvarlatılmış köşeler kullanılmıştır.
  - **Icon** ve **Text** widget'ları ile sayfada dikkat çekici başlıklar ve açıklamalar yer alır.
  - **ElevatedButton** ile şifre sıfırlama butonu yerleştirilmiş, yuvarlatılmış köşeler ve mor renk ile dikkat çekici hale getirilmiştir.
  - Kullanıcı etkileşimini kolaylaştırmak için **TextButton** ve **Divider** gibi öğeler de kullanılmıştır.

- **Kullanıcı Deneyimi (UX)**:
  - **SnackBar** kullanılarak kullanıcıya, şifre sıfırlama bağlantısının gönderildiğine dair bilgi verilir.
  - Kullanıcı, şifre sıfırlama işleminden sonra geri dönmek için **Navigator.pop(context)** ile giriş sayfasına yönlendirilir.

- **Kullanılan Widget'lar**:
  - `Scaffold`: Temel yapı için kullanılır.
  - `TextField`: Kullanıcıdan e-posta almak için kullanılır.
  - `ElevatedButton`: Şifre sıfırlama butonunun stilini ve fonksiyonunu sağlar.
  - `TextButton`: Giriş sayfasına geri dönmek için kullanılır.
  - `SnackBar`: Kullanıcıya şifre sıfırlama işleminin başarıyla tamamlandığını bildirmek için kullanılır.
  - `Icon`: Sayfada logo veya simge olarak kullanılır.
  - `Card`: Sayfa içeriğini stilize etmek için kullanılır.
  - `Divider`: Bölüm ayırıcı çizgi için kullanılır.

Bu sayfa, kullanıcıların şifrelerini sıfırlamalarına olanak tanır ve işlem sonrasında onları bilgilendirir.

  
![Image](https://github.com/user-attachments/assets/c99f9b49-8834-4433-b2b2-ed5b8ab43206)

## 5. Home Sayfası (Ana Sayfa)

### 🎯 Görev
- Kullanıcıya kategori bazlı ve en güncel haberleri göstermek.
- Kaydırmalı haber slider'ı (carousel), kategori filtreleme ve trend haber listesi gibi özelliklerle zengin bir kullanıcı deneyimi sunmak.
- Drawer menüsü ile navigasyon sağlamak (Tüm Haberler, Çıkış).

---

### 🧱 İçerikler ve Bileşenler

#### 📌 AppBar
- Başlık: `"BTNews"` (BT siyah, News mavi renkte)
- Ortalanmış, gölgesiz ve beyaz arka planlı

---

#### 📂 Drawer (Yan Menü)
- **DrawerHeader**: Uygulama logosu (network üzerinden alınan görsel)
- **Log Out**: Kullanıcıyı `Login` sayfasına yönlendirir
- **All News**: Tüm haberleri gösteren `AllNews` sayfasına yönlendirir

---

#### 📚 Kategoriler (CategoryTile)
- Yatay scroll yapılabilir liste
- Her bir kategori kartında görsel ve kategori adı yer alır
- Tıklanıldığında `CategoryNews` sayfasına yönlendirir

---

#### 🚨 Breaking News!
- Başlık: `"Breaking News!"`
- Yanında `"View All"` linki (Tüm haberleri `AllNews` sayfasında açar)
- Altında: `CarouselSlider` bileşeni (slider):
  - İlk 10 haber görsel ve başlıkla birlikte gösterilir
  - Tıklanıldığında `ArticleView` (detay) sayfasına yönlendirir
- Altında: `AnimatedSmoothIndicator` → aktif slider noktasını belirtir

---

#### 🔥 Trending News!
- Başlık: `"Trending News!"`
- Scrollable `ListView.builder` ile tüm haberler listelenir
- Her haber bir `BlogTile` bileşenidir:
  - Görsel + Başlık + Açıklama içerir
  - Tıklanıldığında `ArticleView` sayfasına yönlendirir

---

### 🔄 Yükleme Durumu
- `CircularProgressIndicator` gösterilir, haberler yüklenene kadar

---

### 📦 Kullanılan Paketler
- `cached_network_image`: Haber görsellerini önbellekli yükler
- `carousel_slider`: Kaydırmalı haber slider'ı
- `smooth_page_indicator`: Slider nokta göstergesi
- `webview_flutter`: Haber detaylarında web içeriklerini gösterir

---

### 👨‍💻 Kullanıcı Deneyimi
- Kategorilerle filtreleme yapabilir
- Slider ile hızlıca öne çıkan haberleri gezebilir
- Trend haberleri aşağıda liste halinde görebilir
- Drawer menüsüyle kolay navigasyon

  
![Image](https://github.com/user-attachments/assets/4b177410-325d-428f-8965-374754913852)


### 6. **All News Sayfası**

- **Görev**: Kullanıcılara tüm haberlerin listesini sunar ve her bir haberi tıklanabilir şekilde gösterir. Her tıklama, kullanıcıyı haberin detay sayfasına yönlendirir.
  - **Listeleme**: `articles` adlı liste üzerinden tüm haberler dinamik olarak listelenir.
  - **Tıklama Etkileşimi**: Kullanıcı bir haber başlığına tıkladığında, ilgili haberin detay sayfasına yönlendirilir.
  - **Resim ve Açıklamalar**: Her bir haberin başlık, açıklama ve görseli, kullanıcılara detaylı bir şekilde sunulur.

- **İçerikler**:
  - **Başlık**: Sayfanın üst kısmında `"All News"` başlığı gösterilir.
  - **Haber Kartları**: Her haber için bir **Card** widget'ı kullanılır. Kartlar, başlık, açıklama ve resim içerir.
    - **Resim**: Her haberin görseli, **CachedNetworkImage** widget'ı ile gösterilir. Resim, yüklendikçe bir animasyonla gösterilir.
    - **Başlık**: Haber başlıkları **Text** widget'ı ile görünür. Başlık, taşma durumunda üç nokta (...) ile kısıtlanır.
    - **Açıklama**: Haber açıklamaları da **Text** widget'ı ile gösterilir ve uzun metinlerde taşma durumunda üç nokta ile kısıtlanır.
  - **Tıklanabilirlik**: Her haberin kartına tıklandığında, kullanıcı haberin detay sayfasına yönlendirilir.
  - **Placeholder Resim**: Eğer haberin görseli yoksa veya yüklenemezse, yer tutucu bir resim gösterilir.

- **Tasarım**:
  - **AppBar**: Üst kısımda `"All News"` başlığı bulunan bir **AppBar** bulunur. AppBar, beyaz arka plan ve siyah renkli ikonlarla tasarlanmıştır.
  - **Card**: Haberlerin her biri **Card** widget'ı ile görsel olarak ayrılır. Kartların köşeleri yuvarlatılmıştır.
  - **Row ve Column**: Her bir haberin görseli ve metni bir **Row** içinde, metin kısmı ise **Column** ile düzenlenir. Görselin etrafında boşluk bırakılır ve metinler sola yaslanır.
  - **CachedNetworkImage**: Resimlerin önbelleğe alınarak hızlı bir şekilde gösterilmesi sağlanır. Eğer resim yüklenemezse, yer tutucu bir resim gösterilir.
  - **ElevatedButton**: Her bir haber başlığına tıklandığında, detay sayfasına yönlendirme yapılır.

- **Kullanıcı Deneyimi (UX)**:
  - **Hızlı Görsel Yükleme**: Resimler hızlı bir şekilde yüklenir ve ağ bağlantısı zayıf olsa bile **CachedNetworkImage** sayesinde önbelleğe alınmış görseller gösterilir.
  - **Kolay Erişim**: Kullanıcılar, haberlerin detaylarını kolayca görmek için başlıklara tıklayabilirler.
  - **Dinamik Listeleme**: Haberler liste şeklinde dinamik olarak sıralanır ve kullanıcının ihtiyacına göre ekranı verimli bir şekilde kullanır.

- **Kullanılan Widget'lar**:
  - `Scaffold`: Sayfa yapısı için kullanılır.
  - `AppBar`: Sayfa başlığını ve stilini sağlar.
  - `ListView.builder`: Haberleri dinamik olarak listelemek için kullanılır.
  - `GestureDetector`: Her bir haber kartına tıklanabilirlik ekler.
  - `Card`: Her bir haberin görsel ve metin içeriğini kapsar.
  - `ClipRRect`: Resmin köşelerinin yuvarlatılması için kullanılır.
  - `CachedNetworkImage`: İnternetten alınan görselleri önbelleğe alarak gösterir.
  - `Text`: Başlık ve açıklama metinlerinin görüntülenmesini sağlar.
  - `SizedBox`: Widget'lar arasına boşluk ekler.
  - `MaterialPageRoute`: Kullanıcıyı haberin detay sayfasına yönlendirmek için kullanılır.

Bu sayfa, tüm haberlerin listelendiği, her bir haberin detaylarına tıklanarak ulaşılabilen dinamik bir yapıdır.

![Image](https://github.com/user-attachments/assets/cdc7f3d0-aca3-460a-a8c7-67a615afe2ae)

### 7. **Category News Sayfası**

- **Görev**: Kullanıcının seçtiği haber kategorisine göre ilgili haberleri listeleyen sayfadır. Her bir haber, görsel, başlık ve açıklama ile birlikte gösterilir ve tıklanabilir yapıdadır.
  - Kullanıcının seçtiği kategoriye özel haberleri `ShowCategoryNews` servisi üzerinden çeker.
  - Her bir haberin başlığına tıklanıldığında `ArticleView` sayfasına yönlendirme yapılır.

---

#### ✅ **İşlevler**:

- `getNews()` fonksiyonu:
  - `ShowCategoryNews` sınıfı üzerinden ilgili kategoriye ait haberleri API'den çeker.
  - Gelen verileri `categories` listesine atar.
  - Sayfanın yüklendiğini göstermek için `_loading` değişkenini kullanır.

- `ListView.builder`:
  - `categories` listesine göre dinamik olarak haber kartları oluşturur.

- `ShowCategory` widget'ı:
  - Her haber için görsel, başlık ve açıklamayı gösteren özel bir widget’tır.
  - Habere tıklandığında kullanıcıyı detay sayfasına (`ArticleView`) yönlendirir.

---

#### 📦 **İçerikler**:

- **AppBar**:
  - Başlık: `"News"`
  - Renk: Arka plan beyaz, başlık metni mavi ve kalın yazı tipinde.
  - Ortalanmış başlık ve sıfır elevation.

- **Body**:
  - `ListView.builder`: Kategorideki tüm haberleri listeler.
  - `ShowCategory` kartları:
    - **Resim**: `CachedNetworkImage` ile hızlı ve önbellekli şekilde yüklenir.
    - **Başlık**: Kalın, siyah renkte ve maksimum 2 satırla sınırlı.
    - **Açıklama**: Açıklayıcı metin, maksimum 3 satırla gösterilir.
    - **Tıklanabilirlik**: Kartın tamamı tıklanabilir yapıdadır.

---

#### 🧱 **Kullanılan Yapılar & Widget'lar**:

- `StatefulWidget`: Dinamik veri çekme işlemleri için kullanılır.
- `initState()`: Sayfa açıldığında `getNews()` fonksiyonunun çalışmasını sağlar.
- `ListView.builder`: Haberleri dinamik şekilde listelemek için kullanılır.
- `GestureDetector`: Haberlere tıklanabilirlik ekler.
- `CachedNetworkImage`: Ağdan gelen görselleri önbelleğe alarak optimize yükleme sağlar.
- `ClipRRect`: Görsellerin köşelerini yuvarlatır.
- `MediaQuery`: Görselin genişliğini ekran boyutuna göre ayarlamak için kullanılır.
- `Navigator`: Sayfalar arası geçiş sağlar (`ArticleView` yönlendirmesi).

---

#### 🎯 **Kullanıcı Deneyimi (UX)**:

- **Kategoriye özel içerik**: Kullanıcılar ilgi alanlarına göre içerik görebilir.
- **Hızlı görsel yükleme**: Görsellerin önbellekten hızlı yüklenmesiyle akıcı bir deneyim sunulur.
- **Kolay gezinme**: Habere tıklandığında detaylı sayfaya yönlendirme yapılır.
- **Responsive tasarım**: Görseller ekran boyutuna göre ölçeklenir.

---

Bu sayfa, kullanıcıların belirli bir haber kategorisindeki içerikleri keşfetmelerine ve detay sayfasına kolayca ulaşmalarına imkân tanır.

![Image](https://github.com/user-attachments/assets/1f5833be-5576-4b5e-a417-d31233011609)

## 8. **ArticleView Sayfası**

### 🎯 Görev
- Kullanıcının tıkladığı haberi uygulama içerisinde **WebView** ile görüntüler.
- Haber kaynağının web sitesine yönlendirme yapmadan, uygulama içinden haber okunmasını sağlar.

---

### ✅ İşlevler
- `blogUrl`: Sayfaya parametre olarak gelen haberin URL’sidir.
- `WebViewController`: Web sayfasının yüklenmesini ve kontrolünü sağlar.
  - `setJavaScriptMode(JavaScriptMode.unrestricted)`: JavaScript kullanımını aktif eder.
  - `loadRequest(Uri.parse(blogUrl))`: Haberin URL’sini WebView içinde açar.

---

### 🧱 İçerikler

#### AppBar
- Ortalanmış başlık: `"Flutter News"` olarak yazılır.
  - `"Flutter"` → siyah renkte
  - `"News"` → mavi renkte ve kalın yazı stili
- Arka plan rengi: Beyaz
- Gölge: Yok (`elevation: 0.0`)

#### Body
- `WebViewWidget`: 
  - Haberi doğrudan uygulama içinde gösterir.
  - `WebViewController` üzerinden kontrol edilir.
  - JavaScript desteği açıktır.

---

### 📦 Kullanılan Paketler
- [`webview_flutter`](https://pub.dev/packages/webview_flutter): Web içeriklerini Flutter uygulaması içinde göstermek için kullanılır.

---

### 👨‍💻 Kullanıcı Deneyimi
- Uygulama dışına çıkmadan haber okuma imkânı sunar.
- Temiz ve sade AppBar tasarımı sayesinde dikkat dağıtmadan içerik okunabilir.
- WebView tüm ekranı kapladığı için odaklanmış bir deneyim sağlar.


![Image](https://github.com/user-attachments/assets/bb0ffceb-9f3e-421d-8133-25b7f607d01c)

---

## 9. **ProfileScreen Sayfası**

`ProfileScreen`, Flutter ile geliştirilmiş bir kullanıcı profil görüntüleme ve düzenleme ekranıdır. 

### Özellikler
- Firebase Authentication ile oturum açmış kullanıcının kimliğini doğrular.
- Supabase veritabanından kullanıcının profil bilgilerini (`ad`, `soyad`, `doğum yeri`, `şu an yaşadığı il`, `doğum tarihi`) yükler.
- Eğer kullanıcıya ait profil bilgisi yoksa Supabase üzerinde boş bir profil kaydı oluşturur.
- Kullanıcı form üzerinden profil bilgilerini güncelleyebilir ve bu bilgiler Supabase veritabanında güncellenir.
- Form doğrulama ile boş alanların bırakılması engellenir.
- Yüklenme durumlarında kullanıcıya görsel geri bildirim sağlar.
- Temiz ve kullanıcı dostu bir arayüz ile profil bilgilerini kolayca yönetmeye olanak tanır.
- Form alanları için özel stiller ve ikonlar içerir.

### Kullanılan Teknolojiler
- Flutter (StatefulWidget, Form, TextEditingController)
- Firebase Authentication (Kullanıcı kimlik doğrulama)
- Supabase Flutter SDK (Veritabanı işlemleri için)
- Material Design bileşenleri

### Ana Fonksiyonlar
- `_loadProfileData()`: Supabase'ten mevcut kullanıcı bilgilerini yükler.
- `_createEmptyProfile(String uid)`: Kullanıcı için boş profil oluşturur.
- `_updateProfile()`: Form doğrulandıktan sonra profil bilgilerini Supabase üzerinde günceller veya yeni kayıt oluşturur.
- `_buildTextField()`: Tek bir form alanı oluşturmak için kullanılan yardımcı fonksiyon.

### Kullanım
1. `ProfileScreen` sayfası açıldığında kullanıcı bilgileri Supabase'ten otomatik olarak çekilir.
2. Kullanıcı form alanlarını düzenleyip "Update Profile Information" butonuna basarak bilgilerini güncelleyebilir.
3. Güncelleme sonrası işlem başarılı veya hata durumunda kullanıcı bilgilendirilir.

---

### Notlar
- Kullanıcının oturum açmış olması gerekmektedir.
- Tarih formatı `dd.mm.yyyy` şeklinde beklenmektedir.
- Sayfa, `BasePage` widget'ı üzerine kurulmuştur ve sayfa düzenini sağlar.
- Tüm veritabanı işlemleri `Supabase.instance.client` üzerinden yapılmaktadır.

![Image](https://github.com/user-attachments/assets/5b84a6ef-30ce-4caa-b2be-c006637af985)

# 📱 Drawer Menu (Yan Menü)

## ✨ Özellikler

### 🔐 Kullanıcı Bilgileri
- Firebase Authentication entegrasyonu ile kullanıcı oturum yönetimi
- Firestore'dan kullanıcı adı, soyadı ve e-posta bilgilerinin dinamik olarak çekilmesi
- Kullanıcı profil avatarı gösterimi

### 📱 Navigasyon Sistemi
- **Ana Sayfa**: Uygulamanın ana ekranına yönlendirme
- **Tüm Haberler**: Tüm haber verilerinin listelendiği sayfa
- **Kategori Bazlı Navigasyon**: 
  - 💼 İşletme (Business)
  - 🎬 Eğlence (Entertainment) 
  - 🌍 Genel (General)
  - 🏥 Sağlık (Health)
  - ⚽ Spor (Sports)

### 👤 Profil ve Güvenlik
- Kullanıcı profil sayfasına erişim
- Güvenli çıkış yapma (Onay diyalogu ile)
- Oturum kapatma sonrası login sayfasına yönlendirme

### State Management

- `StatefulWidget` kullanımı
- `initState()` ile otomatik veri çekme
- `setState()` ile dinamik UI güncellemeleri

### Navigasyon Yönetimi

- `Navigator.push()` ile sayfa geçişleri
- `Navigator.pushAndRemoveUntil()` ile stack temizleme
- `MaterialPageRoute` kullanımı

---
![Image](https://github.com/user-attachments/assets/928cd7d2-8033-43d1-8e6b-f7c94d2e8b73)

# Login Bilgilerinin Saklanması (Firebase Authentication)

![Image](https://github.com/user-attachments/assets/57ae7d8c-5fce-4064-a430-8c40f9da3ed5)
### Kullanılan Paketler:
```yaml
 firebase_auth: ^4.6.2
 firebase_core: ^2.24.0
```
# Firestore Database

![Image](https://github.com/user-attachments/assets/7a0396fa-a881-4f77-9713-cb223656bb71)
### Kullanılan Paketler:
```yaml
 cloud_firestore: ^5.6.8
```
## 🛠️ Teknik Özellikler

### Firebase Entegrasyonu
```dart
// Firebase Authentication
FirebaseAuth.instance.currentUser

// Firestore Database
FirebaseFirestore.instance.collection('users')
```
---
# 🗄️ Supabase Database Entegrasyonu
![Image](https://github.com/user-attachments/assets/6b9ab027-7cde-47e2-81ee-03947104d499)

## 📊 Veritabanı Yapısı

### Users Tablosu

Kullanıcı bilgilerini saklamak için aşağıdaki tablo yapısı kullanılmaktadır:

| Sütun        | Tür    | Açıklama                         |
|--------------|--------|---------------------------------|
| id           | text   | Benzersiz kullanıcı kimliği (Primary Key) |
| user_id      | text   | Firebase Auth kullanıcı ID'si    |
| user_name    | text   | Kullanıcının adı                 |
| user_surname | text   | Kullanıcının soyadı             |
| birthplace   | text   | Doğum yeri bilgisi              |
| nowprovince  | text   | Mevcut yaşanılan şehir          |
| birth_date   | date   | Doğum tarihi                    |

---

## 🔧 Supabase Özellikleri

### Real-time Database

- ⚡ **Canlı Veri Senkronizasyonu:** Veritabanı değişiklikleri anlık olarak uygulamaya yansır  
- 🔄 **Otomatik Güncelleme:** Kullanıcı bilgileri değiştiğinde UI otomatik olarak güncellenir

### PostgreSQL Avantajları

- 📈 **Ölçeklenebilir:** Büyük veri setleri için optimize edilmiş  
- 🛡️ **Güvenli:** Row Level Security (RLS) ile veri güvenliği  
- 🚀 **Performanslı:** Indexleme ve optimizasyon özellikleri

### Table Editor

- 🖥️ **Web Tabanlı Yönetim:** Supabase Dashboard üzerinden kolay tablo yönetimi  
- ✏️ **Canlı Düzenleme:** Verileri doğrudan web arayüzünden düzenleme  
- 🔍 **Filtreleme ve Sıralama:** Gelişmiş arama ve filtreleme özellikleri

---

## 🔗 API Entegrasyonu

### REST API

```dart
// Kullanıcı verilerini çekme
final response = await supabase
    .from('users')
    .select()
    .eq('user_id', userId);

// Kullanıcı bilgilerini güncelleme
await supabase
    .from('users')
    .update({
      'user_name': newName,
      'user_surname': newSurname,
    })
    .eq('user_id', userId);
```
### Flutter Entegrasyonu

```yaml
dependencies:
  supabase_flutter: ^2.9.0
```
### Supabase Başlatma
```dart
mport 'package:supabase_flutter/supabase_flutter.dart';

await Supabase.initialize(
  url: 'https://your-project.supabase.co',
  anonKey: 'your-anon-key',
);
```
final supabase = Supabase.instance.client;
### Giriş İşlemi:
```dart
signIn() async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );
```
### Çıkış Yapma:
```dart
ListTile(
          leading: Icon(Icons.logout_rounded),
          title: Text('Log Out'),
          onTap: () {
            Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const Login(), // Çıkış yaptıktan sonra Login sayfasına yönlendir
  ),
);
          },
        ),
```
# Haber API Bilgileri
Kullanılan API: NewsAPI.org

Veri Formatı: JSON

### Örnek API Kullanımı:
```dart
String url = "https://newsapi.org/v2/everything?q=tesla&from=$formattedDate&sortBy=publishedAt&apiKey=8ca749c4e11d4b70a9562dc36918717a";
// HTTP GET isteği gönderiyoruz
    var response = await http.get(Uri.parse(url));
    
    // JSON yanıtını çözümleyerek verileri alıyoruz
    var jsonData = jsonDecode(response.body);
```
### Dönen Veri Örneği:
```dart
ArticleModel articleModel = ArticleModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );
```
# Grup Üyeleri ve Katkıları:
- Tugay Yalçın: Firebase login/signup/forgot işlemleri/Drawer menü ve UI düzenlemeleri
- Berkay Kantaş: API'den veri çekme, kategori filtreleme/Article view sayfası, yönlendirme sistemi/Landing page ve UI düzenlemeleri


