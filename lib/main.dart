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
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Wirid Hari Jumat'), backgroundColor: Colors.black,
        foregroundColor: Colors.white),
        body: const Center(child: Text('Halaman Wirid', style: TextStyle(color: Colors.white))),
      );
    }
  }
  class SholawatPage extends StatelessWidget {
    const SholawatPage({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Kumpulan Sholawat'), backgroundColor: Colors.black,
        foregroundColor: Colors.white),
        body: const Center(child: Text('Halaman Sholawat', style: TextStyle(color: Colors.white))),
      );
    }
  }
  class AmalanPage extends StatelessWidget {
    const AmalanPage({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Amalan Mulia'), backgroundColor: Colors.black,
        foregroundColor: Colors.white),
        body: const Center(child: Text('Halaman Amalan', style: TextStyle(color: Colors.white))),
      );
    }
  }
  class MaulidPage extends StatelessWidget {
    const MaulidPage({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Maulid & Qashidah'), backgroundColor: Colors.black,
        foregroundColor: Colors.white),
        body: const Center(child: Text('Halaman Maulid', style: TextStyle(color: Colors.white))),
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
      else if (judul == "Setelah Sholat Iaya") {
        teksArab = "أَسْتَغْفِرُ اللهَ (٣×) اَللَّهُمَّ أَنْتَ السَّلاَمُ وَمِنْكَ السَّلاَمُ تَبَارَكْتَ يَا ذَا الْجَلاَلِ وَالإِكْرَامِ (١)";
        artiTeks = "1. Aku memohon ampun kepada Allah (3x). Ya Allah, Engkau adalah Maha Penyelamat, dari-Mu lah keselamatan. Maha Suci Engkau, wahai Tuhan Pemilik Keagungan dan Kemuliaan.";
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