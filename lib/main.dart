import 'package:flutter/material.dart';

void main() {
  runApp(const NurKitabApp());
}

class NurKitabApp extends StatelessWidget {
  const NurKitabApp({super.key});

  @override
  Widget build( BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nur_kitab',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF004D40),
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(primary: Colors.teal),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    int currentIndex = 0;

    @override
    Widget build(BuildContext context) {
      final pages = [
        const HomeContent(),
        const PrayerSchedulePage(),
        const ProfilePage(),
      ];
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: const Icon(Icons.search, color: Colors.teal),
          title: const Text(
            'نورالکتاب',
            style: TextStyle(fontFamily: 'Serif',
            color: Colors.teal, fontSize: 24),          
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.settings, color: Colors.teal),
          SizedBox(width: 16),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => 
        currentIndex = index), 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Jadwal'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],    
        ),
      );
    }
  }

  class HomeContent extends StatelessWidget {
    const HomeContent({super.key});

    @override
    Widget build(BuildContext context) {
      return ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildWideCard(context,'Al-Qur\'an', AlQuranPage(), false),
          _buildWideCard(context, 'Dzikir Siang-Malam', DzikirPage(), false),
          _buildWideCard(context, 'Wirid Hari Jumat',  WiridPage(),false),
          _buildWideCard(context, 'Kumpulan Bacaan Sholawat', SholawatPage(), true),
          
          Row(
            children: [
              Expanded(child: _buildSquareCard(context,'Amalan Mulia', AmalanPage(), false)),
              const SizedBox(width: 8),
              Expanded(child: _buildSquareCard(context, 'Maulid & Qashidah', MaulidPage(), false)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildSquareCard(context, 'Tuntunan Ziarah', TuntunanPage(), false)),
              const SizedBox(width: 8),
              Expanded(child: _buildSquareCard(context, 'Hizib & Ratib', HizibPage(), true)),
            ],
          ),
        ],
      );
    }

    Widget _buildWideCard(BuildContext context, title, Widget targetPage, bool isNew) {
      return GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage)),
        child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: _cardDecoration(),
        child: Stack(
          children: [
            if (isNew) _badgeNew(),
            Center(
              child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
          ),
        ),
      );
    }

    Widget _buildSquareCard(BuildContext context, title, Widget targetPage, bool isNew) {
      return GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage)),
        child: Container(
        height: 120,
        decoration: _cardDecoration(),
        child: Stack(
          children: [
            if (isNew) _badgeNew(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
        ),
      );
    }

    BoxDecoration _cardDecoration() {
      return BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
        image: NetworkImage('https://cdn.prod.website-files.com/65af5f0812c914d3fef6a68c/65f27c26e1af10be0127caf2_5.%20Menggali%20Kearifan%20Spiritual%20dalam%20Petunjuk%20Al-Quran.jpg'),
        opacity: 0.3,
        fit: BoxFit.cover,
        ),
      );
    }

    Widget _badgeNew() {
      return Positioned(
        top: 8, left: 8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Colors.teal[700], borderRadius: BorderRadius.circular(4)),
          child: const Text('baru', style: TextStyle(fontSize: 10)),
        ),
      );
    }
  }

  class PrayerSchedulePage extends StatelessWidget {
    const PrayerSchedulePage({super.key});

    @override
    Widget build(BuildContext context) {
      final prayers = {
        'Imsak': '04:10', 
        'subuh': '04:20', 
        'Terbit': '05:35',
        'Dzuhur': '11:38', 
        'Ashar': '14:58', 
        'Maghrib': '17:35', 
        'Isya': '18:47',
      };
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Colors.teal[900],
            child: const Column(
              children: [
                Text('Jakarta, Indonesia', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('17:35', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                Text('Menuju Maghrib', style: TextStyle(color: Colors.tealAccent)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
            padding: const EdgeInsets.all(16),
            children: prayers.entries.map((e) => 
            Card(
              color: Colors.grey[900],
              child: ListTile(
                title: Text(e.key),
                trailing: Text(e.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                leading: const Icon(Icons.notifications_none, color: Colors.teal),
              ),
            )).toList(),
            ),
          ),
        ],
      );
    }
  }

  class ProfilePage extends StatelessWidget{
      const ProfilePage({super.key});

      @override
      Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, size: 50, color: Colors.white), 
              ),
              const SizedBox(height: 20),
              const Text("Umar", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text('Developer Nur_Kitab', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              Card(
                color: Colors.grey[900],
                child: const ListTile(
                  leading: Icon(Icons.info, color: Colors.teal),
                  title: Text('Versi Aplikasi'),
                  trailing: Text('1.0.0'),
                ),
              ),
            ],
          ),
        );
    }
  }
    
  class AlQuranPage extends StatelessWidget {
    const AlQuranPage({super.key});
    @override


    Widget build(BuildContext context) {
      final List<String> surah = ["Al-Fatihah",
      "Al-Ikhlas", "Al-Falaq", "An-Nas"];
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Al-Qur\'an'), backgroundColor: Colors.black, foregroundColor: Colors.white),
        body: ListView.builder(
          itemCount: surah.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading:  CircleAvatar(backgroundColor: Colors.teal, child: Text("${index + 1}", style: const TextStyle(color: Colors.white))),
              title: Text(surah[index], style: const TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 14),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => IsiBacaanPage(judul: surah[index]),
                  ));
              },
            );
          },
        ),
      );
    }
  }
  class DzikirPage extends StatelessWidget {
    const DzikirPage({super.key});

    @override
    Widget build(BuildContext context) {
      final List<Map<String, dynamic>> menuDzikir = [
        {"judul": "Dzikir Pagi", "ikon": Icons.wb_sunny},
        {"judul": "Dzikir Petang", "ikon": Icons.nightlight_round},
        {"judul": "Setelah Sholat Subuh", "ikon": Icons.wb_twilight},
        {"judul": "Setelah Sholat Dzuhur", "ikon": Icons.wb_sunny_rounded},
        {"judul": "Setelah Sholat Ashar", "ikon": Icons.wb_cloudy},
        {"judul": "Setelah Sholat Maghrib", "ikon": Icons.dark_mode},
        {"judul": "Setelah Sholat Isya", "ikon": Icons.bedtime},
      ];
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Dzikir Siang-Malam'), backgroundColor: Colors.black,
        foregroundColor: Colors.white),
        body: ListView.builder(
          itemCount: menuDzikir.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(menuDzikir[index] ['ikon'], color: Colors.teal),
              title: Text(menuDzikir[index] ['judul'], 
              style: const TextStyle(color: Colors.white)
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 14),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => IsiBacaanPage(judul: menuDzikir[index] ['judul']),
                ));
              },
            );
          },
        ),
      );
    }
  }
  class WiridPage extends StatelessWidget {
    const WiridPage({super.key});
    @override

    Widget build(BuildContext context) {
      final List<String> wirid = [
        "Tasbih (Subhanallah)",
        "Tahmid (Alhamdulillah)",
        "Takbir (Allahu Akbar)",
        "Tahlil (Laa Ilaha Illallah)",
        "Ayat Kursi",
      ];
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Wirid Hari Jumat'), backgroundColor: Colors.black,
        foregroundColor: Colors.white),
        body: ListView.builder(
          itemCount: wirid.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.star_border_purple500_rounded, color: Colors.teal),
              title: Text(wirid[index], 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 14),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => IsiBacaanPage(judul: wirid[index]),
                ));
              },
            );
          },
        ),
      );
    }
  }
  class SholawatPage extends StatelessWidget {
    const SholawatPage({super.key});

    @override
    Widget build(BuildContext context) {
      final List<String> sholawat = [
        "Sholawat Ibrahimiyah",
        "Sholawat Jibril",
        "Sholawat Nariyah",
        "Sholawat Munjiyat",
      ];
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Kumpulan Sholawat'), backgroundColor: Colors.black,
        foregroundColor: Colors.white),
        body: ListView.builder(
          itemCount: sholawat.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.favorite_border_rounded, color: Colors.teal),
              title: Text(
                sholawat[index],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 14),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => IsiBacaanPage(judul: sholawat[index]),
                ));
              },
            );
          },),
      );
    }
  }
  class AmalanPage extends StatelessWidget {
    const AmalanPage({super.key});
    @override
    Widget build(BuildContext context) {
      final List<String> amalan = [
        "Amalan Sebelum Tidur",
        "Sayyidul Istighfar",
        "Doa Sapu Jagat",
        "Doa Kedua Orang Tua",
      ];
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Amalan Mulia'), backgroundColor: Colors.black,
        foregroundColor: Colors.white),
        body: ListView.builder(
          itemCount: amalan.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.wb_sunny_rounded, color: Colors.teal),
              title: Text(
                amalan[index],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 14),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => IsiBacaanPage(judul: amalan[index]),
                ));
              },
            );
          },
        )
      );
    }
  }
  class MaulidPage extends StatelessWidget {
    const MaulidPage({super.key});
    @override
    Widget build(BuildContext context) {
      final List<String> maulid = [
        "Maulid Simtutdurar (pembuka)",
        "Qashidah Burdah (Bab 1)",
        "Qashidah Ya Imamarusli",
        "Qashidah Busro Lana",
      ];
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Maulid & Qashidah'), backgroundColor: Colors.black,
        foregroundColor: Colors.white),
        body: ListView.builder(
          itemCount: maulid.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.wb_sunny_rounded, color: Colors.teal),
              title: Text(
                maulid[index],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 14),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => IsiBacaanPage(judul: maulid[index]),
                ));
              },
            );
          },
        )
      );
    }
  }
  class TuntunanPage extends StatelessWidget {
    const TuntunanPage({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Tuntunan Ziarah'), backgroundColor: Colors.black,
        foregroundColor: Colors.white),
        body: const Center(child: Text('Halaman Tuntunan', style: TextStyle(color: Colors.white))),
      );
    }
  }
  class HizibPage extends StatelessWidget {
    const HizibPage({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Hizib & Ratib'), backgroundColor: Colors.black,
        foregroundColor: Colors.white),
        body: const Center(child: Text('Halaman Hizib', style: TextStyle(color: Colors.white))),
      );
    }
  }
  
  class IsiBacaanPage extends StatelessWidget {
    final String judul;
    const IsiBacaanPage({super.key, required this.judul});

    @override
    Widget build(BuildContext context) {
      String teksArab = "";
      String artiTeks = "";

      if (judul == "Al-Fatihah") {
        teksArab = "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ (١) اَلْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِيْنَ (٢) الرَّحْمٰنِ الرَّحِيْمِ (٣) مٰلِكِ يَوْمِ الدِّيْنِ (٤) اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِيْنُ (٥) اِهْدِنَا الصِّرَاطَ الْمُسْتَقِيْمَ (٦) صِرَاطَ الَّذِيْنَ اَنْعَمْتَ عَلَيْهِمْ ەۙ غَيْرِ الْمَغْضُوْبِ عَلَيْهِمْ وَلَا الضَّاۤلِّيْنَ (٧)";
        artiTeks = "1. Dengan nama Allah Yang Maha Pengasih, Maha Penyayang. 2. Segala puji bagi Allah, Tuhan seluruh alam. 3. Yang Maha Pengasih, Maha Penyayang. 4. Pemilik hari pembalasan. 5. Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami mohon pertolongan. 6. Bimbinglah kami ke jalan yang lurus. 7. (yaitu) jalan orang-orang yang telah Engkau beri nikmat, bukan (jalan) mereka yang dimurkai dan bukan (pula jalan) mereka yang sesat.";
      }
      else if (judul == "Al-Ikhlas") {
        teksArab = "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ. قُلْ هُوَ اللّٰهُ اَحَدٌ (١) اَللّٰهُ الصَّمَدُ (٢) لَمْ يَلِدْ وَلَمْ يُولَدْ (٣) وَلَمْ يَكُنْ لَّهٗ كُفُوًا اَحَدٌ (٤)";
        artiTeks = "1. Katakanlah (Muhammad), Dialah Allah, Yang Maha Esa. 2. Allah tempat meminta segala sesuatu. 3. (Allah) tidak beranak dan tidak pula diperanakkan. 4. Dan tidak ada sesuatu yang setara dengan Dia.";
      }
      else if (judul == "Al-Falaq") {
        teksArab = "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ. قُلْ اَعُوْذُ بِرَبِّ الْفَلَقِ (١) مِنْ شَرِّ مَا خَلَقَ (٢) وَمِنْ شَرِّ غَاسِقٍ اِذَا وَقَبَ (٣) وَمِنْ شَرِّ النَّفّٰثٰتِ فِى الْعُقَدِ (٤) وَمِنْ شَرِّ حَاسِدٍ اِذَا حَسَدَ (٥)";
        artiTeks = "1. Katakanlah, Aku berlindung kepada Tuhan yang menguasai subuh (fajar), \n2. dari kejahatan (makhluk yang) Dia ciptakan, \n3. dan dari kejahatan malam apabila telah gelap gulita, \n4. dan dari kejahatan (perempuan-perempuan) penyihir yang meniup pada buhul-buhul (talinya), \n5. dan dari kejahatan orang yang dengki apabila dia dengki.";
      }
      else if (judul == "An-Nas") {
        teksArab = "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ. قُلْ اَعُوْذُ بِرَبِّ النَّاسِ (١) مَلِكِ النَّاسِ (٢) اِلٰهِ النَّاسِ (٣) مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ (٤) الَّذِيْ يُوَسْوِسُ فِيْ صُدُوْرِ النَّاسِ (٥) مِنَ الْجِنَّةِ وَالنَّاسِ (٦)";
        artiTeks = "1. Katakanlah, Aku berlindung kepada Tuhannya manusia, \n2. Raja manusia, \n3. Sembahan manusia, \n4. dari kejahatan (bisikan) setan yang bersembunyi, \n5. yang membisikkan (kejahatan) ke dalam dada manusia, \n6. dari (golongan) jin dan manusia.";
      }

      // -- BAGIAN DZIKIR --
      else if (judul == "Dzikir Pagi") {
        teksArab = "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ (١)";
        artiTeks = "1. Kami memasuki waktu pagi dan kerajaan hanya milik Allah, segala puji bagi Allah. Tidak ada tuhan yang berhak disembah kecuali Allah semata, tidak ada sekutu bagi-Nya.";
      }
      else if (judul == "Dzikir Petang") {
        teksArab = "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ (١)";
        artiTeks = "1. Kami memasuki waktu petang dan kerajaan hanya milik Allah, segala puji bagi Allah. Tidak ada tuhan yang berhak disembah kecuali Allah semata, tidak ada sekutu bagi-Nya.";
      }
      else if (judul == "Setelah Sholat Subuh") {
        teksArab = "أَسْتَغْفِرُ اللهَ (٣×) اَللَّهُمَّ أَنْتَ السَّلاَمُ وَمِنْكَ السَّلاَمُ تَبَارَكْتَ يَا ذَا الْجَلاَلِ وَالإِكْرَامِ (١) اَللَّهُمَّ أَجِرْنِي مِنَ النَّارِ (٧×) (٢)";
        artiTeks = "1. Aku memohon ampun kepada Allah (3x). Ya Allah, Engkau adalah Maha Penyelamat, dari-Mu lah keselamatan. Maha Suci Engkau, wahai Tuhan Pemilik Keagungan dan Kemuliaan. \n2. Ya Allah, lindungilah aku dari api neraka (7x setelah subuh).";
      }
      else if (judul == "Setelah Sholat Dzuhur") {
        teksArab = "أَسْتَغْفِرُ اللهَ (٣×) اَللَّهُمَّ أَنْتَ السَّلاَمُ وَمِنْكَ السَّلاَمُ تَبَارَكْتَ يَا ذَا الْجَلاَلِ وَالإِكْرَامِ (١) لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ Lَهُ (٢)";
        artiTeks = "1. Aku memohon ampun kepada Allah (3x). Ya Allah, Engkau adalah Maha Penyelamat... \n2. Tidak ada tuhan yang berhak disembah kecuali Allah semata.";
      }
      else if (judul == "Setelah Sholat Ashar") {
        teksArab = "أَسْتَغْفِرُ اللهَ (٣×) اَللَّهُمَّ أَنْتَ السَّلاَمُ وَمِنْكَ السَّلاَمُ تَبَارَكْتَ يَا ذَا الْجَلاَلِ وَالإِكْرَامِ (١)";
        artiTeks = "1. Aku memohon ampun kepada Allah (3x). Ya Allah, Engkau adalah Maha Penyelamat, dari-Mu lah keselamatan. Maha Suci Engkau, wahai Tuhan Pemilik Keagungan dan Kemuliaan.";
      }
      else if (judul == "Setelah Sholat Maghrib") {
        teksArab = "أَسْتَغْفِرُ اللهَ (٣×) اَللَّهُمَّ أَنْتَ السَّلاَمُ وَمِنْكَ السَّلاَمُ تَبَارَكْتَ يَا ذَا الْجَلاَلِ وَالإِكْرَامِ (١) اَللَّهُمَّ أَجِرْنِي مِنَ النَّارِ (٧×) (٢)";
        artiTeks = "1. Aku memohon ampun kepada Allah (3x). Ya Allah, Engkau adalah Maha Penyelamat... \n2. Ya Allah, lindungilah aku dari api neraka (7x setelah maghrib).";
      }
      else if (judul == "Setelah Sholat Isya") {
        teksArab = "أَسْتَغْفِرُ اللهَ (٣×) اَللَّهُمَّ أَنْتَ السَّلاَمُ وَمِنْكَ السَّلاَمُ تَبَارَكْتَ يَا ذَا الْجَلاَلِ وَالإِكْرَامِ (١)";
        artiTeks = "1. Aku memohon ampun kepada Allah (3x). Ya Allah, Engkau adalah Maha Penyelamat, dari-Mu lah keselamatan. Maha Suci Engkau, wahai Tuhan Pemilik Keagungan dan Kemuliaan.";
      }

      // -- BAGIAN WIRID --
      else if (judul == "Tasbih (Subhanallah)") {
        teksArab = "سُبْحَانَ اللهِ (٣٣×)";
        artiTeks = "Maha Suci Allah. \n(Dibaca sebanyak 33 kali setelah sholat fardhu.";
      }
      else if (judul == "Tahmid (Alhamdulillah)") {
        teksArab = "الْحَمْدُ لِلَّهِ (٣٣×)";
        artiTeks = "Segala puji bagi Allah. \n(Dibaca sebanyak 33 kali setelah sholat fardhu.";
      }
      else if (judul == "Takbir (Allahu Akbar)") {
        teksArab = "اللهُ أَكْبَرُ (٣٣×)";
        artiTeks = "Allah Maha Besar. \n(Dibaca sebanyak 33 kali setelah sholat fardhu.";
      }
      else if (judul == "Tahlil (Laa Ilaha Illallah)") {
        teksArab = "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ";
        artiTeks = "Tidak ada tuhan yang berhak disembah kecuali Allah semata, tidak ada sekutu bagi-Nya. Bagi-Nya kerajaan dan bagi-Nya segala puji. Dan Dia Maha Kuasa atas segala sesuatu.";
      }
      else if (judul == "Ayat Kursi") {
        teksArab = "اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ";
        artiTeks = "Allah, tidak ada tuhan selain Dia. Yang Maha Hidup, yang terus-menerus mengurus (makhluk-Nya), tidak mengantuk dan tidak tidur. Milik-Nya apa yang ada di langit dan apa yang ada di bumi. Tidak ada yang dapat memberi syafaat di sisi-Nya tanpa izin-Nya. Dia mengetahui apa yang di hadapan mereka dan apa yang di belakang mereka, dan mereka tidak mengetahui sesuatu apa pun dari ilmu-Nya melainkan apa yang Dia kehendaki. Kursi-Nya meliputi langit dan bumi. Dan Dia tidak merasa berat memelihara keduanya, Dan Dia Maha Tinggi, Maha Besar.";
      }

      // -- SHOLAWAT --
      else if (judul == "Sholawat Ibrahimiyah") {
        teksArab = "اَللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ  مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ وَبَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ فِي الْعَالَمِينَ إِنَّكَ حَمِيدٌ مَجِيدٌ";
        artiTeks = "Ya Allah, limpahkanlah rahmat kepada Nabi Muhammad dan kepada keluarga Nabi Muhammad, sebagaimana Engkau telah melimpahkan rahmat kepada Nabi Ibrahim dan kepada keluarga Nabi Ibrahim. Dan berkahilah Nabi Muhammad dan keluarga Nabi Muhammad, sebagaimana Engkau telah memberkahi Nabi Ibrahim dan keluarga Nabi Ibrahim. Sesungguhnya di seluruh alam semesta ini, Engkau Maha Terpuji lagi Maha Mulia.";
      }
      else if (judul == "Sholawat Jibril") {
        teksArab = "صَلَّى اللهُ عَلَى مُحَمَّدٍ";
        artiTeks = "Semoga Allah memberikan rahmat-Nya kepada Nabi Muhammad. \n(Sholawat singkat penarik rezeki.";
      }
      else if (judul == "Sholawat Nariyah") {
        teksArab = "اَللَّهُمَّ صَلِّ صَلَاةً كَامِلَةً وَسَلِّمْ سَلَامًا تَامًّا عَلَى سَيِّدِنَا مُحَمَّدٍ الَّذِي تَنْحَلُّ بِهِ الْعُقَدُ وَتَنْفَرِجُ بِهِ الْكُرَبُ وَتُقْضَى بِهِ الْحَوَائِجُ وَتُنَالُ بِهِ الرَّغَائِبُ وَحُسْنُ الْخَوَاتِمِ وَيُسْتَسْقَى الْغَمَامُ بِوَجْهِهِ الْكَرِيمِ وَعَلَى آلِهِ وَصَحْبِهِ فِي كُلِّ لَمْحَةٍ وَنَفَسٍ بِعَدَدِ كُلِّ مَعْلُومٍ لَكَ";
        artiTeks = "Ya Allah, limpahkanlah shalawat yang sempurna dan kesejahteraan yang paripurna kepada junjungan kami Nabi Muhammad, yang dengan perantaraannya semua ikatan terlepas, segala kesusahan dihilangkan, segala kebutuhan dipenuhi, segala keinginan dan akhir yang baik tercapai, dan hujan diturunkan berkat wajahnya yang mulia. Begitu pula kepada keluarga dan para sahabatnya pada setiap kedipan mata dan hembusan nafas, sebanyak jumlah semua yang Engkau ketahui.";
      }
      else if (judul == "Sholawat Munjiyat") {
        teksArab = "اَللَّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ صَلَاةً تُنْجِينَا بِهَا مِنْ جَمِيعِ الْأَهْوَالِ وَالْآفَاتِ وَتَقْضِي لَنَا بِهَا جَمِيعَ الْحَاجَاتِ وَتُطَهِّرُنَا بِهَا مِنْ جَمِيعِ السَّيِّئَاتِ وَتَرْفَعُنَا بِهَا عِنْدَكَ أَعْلَى الدَّرَجَاتِ وَتُبَلِّغُنَا بِهَا أَقْصَى الْغَايَاتِ مِنْ جَمِيعِ الْخَيْرَاتِ فِي الْحَيَاةِ وَبَعْدَ الْمَمَاتِ";
        artiTeks = "Ya Allah, limpahkanlah rahmat kepada junjungan kami Nabi Muhammad, yang dengan shalawat itu Engkau akan menyelamatkan kami dari semua keadaan yang menakutkan dan dari semua malapetaka, Engkau akan memenuhi semua kebutuhan kami, Engkau akan membersihkan kami dari semua keburukan, Engkau akan mengangkat kami ke derajat tertinggi di sisi-Mu, dan Engkau akan menyampaikan kami kepada tujuan yang paling sempurna dari semua kebaikan, baik semasa hidup maupun setelah mati.";
      }

      //  -- BAGIAN AMALAN -- 
      else if (judul == "Amalan Sebelum Tidur") {
        teksArab = "بِاسْمِكَ اللّٰهُمَّ أَحْيَا وَبِاسْمِكَ أَمُوْتُ (١)\n\n"
                  "اَللّٰهُمَّ قِنِيْ عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ (٢)";
        artiTeks = "1. Dengan nama-Mu ya Allah aku hidup dan dengan nama-Mu aku mati.\n\n"
                  "2. Ya Allah, jagalah aku dari siksa-Mu pada hari yang Engkau membangkitkan hamba-hamba-Mu.\n\n"
                  "Note: Sebelum membaca doa ini, disunnahkan juga membaca Ayat Kursi, Al-Ikhlas, Al-Falaq, dan An-Nas lalu ditiupkan ke telapak tangan dan diusap ke seluruh tubuh.";
      }
      else if (judul == "Sayyidul Istighfar") {
        teksArab = "اَللَّهُمَّ أَنْتَ رَبِّيْ لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِيْ وَأَنَا عَبْدُكَ وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوْذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوْءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوْءُ بِذَنْبِيْ فَاغْفِرْ لِيْ فَإِنَّهُ لَا يَغْفِرُ الذُّنُوْبَ إِلَّا أَنْتَ";
        artiTeks = "Ya Allah, Engkau adalah Tuhanku, tidak ada tuhan yang berhak disembah kecuali Engkau. Engkau yang menciptakanku dan aku adalah hamba-Mu. Aku menetapi perjanjian-Mu dan janji-Mu sesuai kemampuanku. Aku berlindung kepada-Mu dari keburukan perbuatanku, aku mengakui nikmat-Mu kepadaku dan aku mengakui dosaku, maka ampunilah aku. Sebab, tidak ada yang dapat mengampuni dosa melainkan Engkau.";
      }
      else if (judul == "Doa Sapu Jagat") {
        teksArab = "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ";
        artiTeks = "Ya Tuhan kami, berilah kami kebaikan di dunia dan kebaikan di akhirat, dan lindungilah kami dari azab neraka.";
      }
      else if (judul == "Doa Kedua Orang Tua") {
        teksArab = "رَبِّ اغْفِرْ لِيْ وَلِوَالِدَيَّ وَارْحَمْهُمَا كَمَا رَبَّيَانِيْ صَغِيْرًا";
        artiTeks = "Ya Tuhanku, ampunilah dosaku dan dosa kedua orang tuaku, dan sayangilah mereka sebagaimana mereka berdua telah mendidikku di waktu kecil.";
      }

      //-- BAGIAN MAULID & QASHIDAH --
      else if (judul == "Maulid Simtuddurar (Pembuka)") {
        teksArab = "بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ. اَلْحَمْدُ لِلّٰهِ الْقَوِيِّ سُلْطَانُهْ، الْوَاضِحِ بُرْهَانُهْ، الْمَبْسُوْطِ فِي الْوُجُوْدِ كَرَمُهُ وَإِحْسَانُهْ";
        artiTeks = "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang. Segala puji bagi Allah Yang Maha Kuat kekuasaan-Nya, Maha Jelas bukti-bukti-Nya, dan Maha Luas kedermawanan serta kebaikan-Nya di alam semesta ini.";
      }
      else if (judul == "Qashidah Burdah (Bab 1)") {
        teksArab = "أَمِنْ تَذَكُّـرِ جِيْـرَانٍ بِـذِيْ سَلَمِ ❁ مَزَجْتَ دَمْعاً جَرَى مِنْ مُقْلَةٍ بِدَمِ \n\nأَمْ هَبَّتِ الرِّيْحُ مِنْ تِلْقَاءِ كَاظِمَةٍ ❁ وَأَوْمَضَ الْبَرْقُ فِي الظَّلْمَاءِ مِنْ إِضَمِ";
        artiTeks = "1. Apakah karena teringat tetangga yang tinggal di Dzi Salam, engkau mengucurkan air mata bercampur darah yang mengalir dari matamu? \n\n2. Ataukah karena angin berembus dari arah Kazhimah, dan kilat berkilauan di dalam kegelapan malam dari gunung Idham?.";
      }
      else if (judul == "Qashidah Ya Imamarusli") {
        teksArab ="يَا إِمَامَ الرُّسْلِ يَا سَنَدِيْ ❁ أَنْتَ بَابُ اللهِ مُعْتَمَدِيْ\n"
                  "فَبِدُنْيَايَ وَآخِرَتِيْ ❁ يَا رَسُوْلَ اللهِ خُذْ بِيَدِيْ (١)\n\n"
                  "قَسَمًا بِالنَّجْمِ حِيْنَ هَوَى ❁ مَا الْمُعَافَى وَالسَّقِيْمُ سَوَى\n"
                  "فَاخْلَعِ الْكَوْنَيْنِ عَنْكَ سِوَى ❁ حُبِّ مَوْلَى الْعُرْبِ وَالْعَجَمِ (٢)\n\n"
                  "وَأَزِحْ مَا اسْتَطَعْتَ مِنْ عِلَلٍ ❁ عَنْ كَلَامٍ فِيْكَ ذِيْ زَلَلٍ\n"
                  "وَانْتَبِهْ مِنْ رَقْدَةِ الْغَفَلِ ❁ وَاحْتَمِ فِيْ جَاهِ ذِيْ الْعِصَمِ (٣)";
        artiTeks = "1. Wahai pemimpin para Rasul, wahai sandaranku! Engkaulah pintu Allah tumpuanku. Maka di dunia dan akhiratku, wahai Rasulullah, peganglah tanganku (bimbinglah aku).\n\n"
                  "2. Aku bersumpah demi bintang ketika terbenam, tidaklah sama orang yang sehat dengan orang yang sakit. Maka lepaskanlah keterikatan dua alam darimu, kecuali cinta kepada pemimpin bangsa Arab dan ajam (Nabi Muhammad).\n\n"
                  "3. Dan hilangkanlah sejauh kemampuanmu dari segala cacat, dari perkataan yang menggelincirkanmu. Dan bangunlah dari tidur kelalaian, serta berlindunglah di bawah kemuliaan Nabi yang terjaga dari dosa.";
      }
      else if (judul == "Qashidah Busro Lana") {
        teksArab ="بُشْرَى لَنَا نِلْنَا الْمُنَى ❁ زَالَ الْعَنَا وَافَى الصَّفَا\n"
                  "وَالدَّهْرُ أَنْجَزَ وَعْدَهُ ❁ وَالْبِشْرُ أَضْحَى مُعْلَنَا (١)\n\n"
                  "يَا نَفْسُ طِيْبِيْ بِاللِّقَا ❁ يَا عَيْنُ قَرِّيْ أَعْيُنَا\n"
                  "هٰذَا جَمَالُ الْمُصْطَفَى ❁ أَنْوَارُهُ لَاحَتْ لَنَا (٢)\n\n"
                  "يَا طَيْبَةُ مَاذَا نَقُوْلْ ❁ وَفِيْكِ قَدْ حَلَّ الرَّسُوْلْ\n"
                  "وَكُلُّنَا نَرْجُوْ الْوُصُوْلْ ❁ لِمُحَمَّدٍ نَبِيِّنَا (٣)\n\n"
                  "صَلَّى عَلَيْهِ اللهُ بَارْ ❁ كُلَّ الْعَشَايَا وَالْأَبْكَارْ\n"
                  "وَآلِهِ الْأَطْهَارِ الْأَخْيَارْ ❁ أَصْحَابِهِ أَهْلِ الْهُدَى (٤)";
        artiTeks = "1. Kabar gembira bagi kami karena kami telah mencapai cita-cita. Segala kesulitan telah sirna dan kesucian telah datang. Waktu telah menepati janjinya, dan kegembiraan kini telah nyata diumumkan.\n\n"
                  "2. Wahai jiwa, bahagia lah dengan pertemuan ini! Wahai mata, sejukkanlah pandangan kami! Ini adalah keindahan Al-Musthafa (Nabi pilihan), cahaya-cahayanya telah tampak terang bagi kami.\n\n"
                  "3. Wahai kota Thaybah (Madinah), apa yang bisa kami katakan? Sedangkan di dalam dirimu telah tinggal sang Rasul. Dan kami semua berharap untuk bisa sampai kepada Muhammad, Nabi kami.\n\n"
                  "4. Semoga Allah Sang Pencipta melimpahkan sholawat kepadanya setiap malam dan pagi hari, juga kepada keluarganya yang suci lagi mulia, serta para sahabatnya yang merupakan ahli petunjuk.";
      }

      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: Text(judul),
        backgroundColor: Colors.black, foregroundColor: Colors.white),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(
              teksArab,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                height: 2.2,
                fontFamily: 'Serif'
              ),
              textAlign: TextAlign.right,
            ),
            const Divider(color: Colors.teal, height: 30),
            Text(
              artiTeks,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }
  }