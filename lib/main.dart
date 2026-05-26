import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const NurKitabApp());
}

class NurKitabApp extends StatelessWidget {
  const NurKitabApp({super.key});

  @override
  Widget build(BuildContext context) {
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  // State Utama Pengaturan Aplikasi (Mengontrol Warna, Terjemahan, & Ukuran Font)
  bool isDarkMode = true;
  bool tampilkanTerjemahan = true;
  double skalaFont = 1.0;

  @override
  Widget build(BuildContext context) {
    // Penyesuaian tema warna dinamis berdasarkan toggle settings
    final warnaBackground = isDarkMode ? Colors.black : Colors.white;
    final warnaAppBar = isDarkMode ? Colors.black : Colors.teal;
    final warnaTeksAppBar = isDarkMode ? Colors.teal : Colors.white;
    final warnaNavBg = isDarkMode ? Colors.black : Colors.grey[200];
    final warnaNavUnselected = isDarkMode ? Colors.grey : Colors.grey[600];

    // List Halaman Aplikasi dengan melemparkan parameter state ke halaman terkait
    final pages = [
      HomeContent(skalaFont: skalaFont, tampilkanTerjemahan: tampilkanTerjemahan, isDarkMode: isDarkMode),
      const PrayerSchedulePage(),
      ProfilePage(
        isDarkMode: isDarkMode,
        tampilkanTerjemahan: tampilkanTerjemahan,
        skalaFont: skalaFont,
        onThemeChanged: (nilai) => setState(() => isDarkMode = nilai),
        onTranslationChanged: (nilai) => setState(() => tampilkanTerjemahan = nilai),
        onFontSizeChanged: (nilai) => setState(() => skalaFont = nilai),
      ),
    ];

    return Scaffold(
      backgroundColor: warnaBackground,
      appBar: AppBar(
        backgroundColor: warnaAppBar,
        elevation: 0,
        title: Text(
          'نورالکتاب',
          style: TextStyle(fontFamily: 'Serif', color: warnaTeksAppBar, fontSize: 24),          
        ),
        centerTitle: true,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: warnaNavBg,
        selectedItemColor: Colors.teal,
        unselectedItemColor: warnaNavUnselected,
        onTap: (index) => setState(() => currentIndex = index), 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Jadwal'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'), 
        ],    
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final double skalaFont;
  final bool tampilkanTerjemahan;
  final bool isDarkMode;

  const HomeContent({
    super.key,
    required this.skalaFont,
    required this.tampilkanTerjemahan,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _buildWideCard(context, 'Al-Qur\'an', SurahPendekPage(skalaFont: skalaFont, tampilkanTerjemahan: tampilkanTerjemahan, isDarkMode: isDarkMode), false),
        _buildWideCard(context, 'Kumpulan Bacaan Sholawat', SholawatPage(skalaFont: skalaFont, tampilkanTerjemahan: tampilkanTerjemahan, isDarkMode: isDarkMode), true),
        
        Row(
          children: [
            Expanded(child: _buildSquareCard(context, 'Maulid & Qashidah', MaulidPage(skalaFont: skalaFont, tampilkanTerjemahan: tampilkanTerjemahan, isDarkMode: isDarkMode), false)),
            const SizedBox(width: 8),
            Expanded(child: _buildSquareCard(context, 'Hizib & Ratib', HizibPage(skalaFont: skalaFont, tampilkanTerjemahan: tampilkanTerjemahan, isDarkMode: isDarkMode), true)),
          ],
        ),
      ],
    );
  }

  Widget _buildWideCard(BuildContext context, String title, Widget targetPage, bool isNew) {
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

  Widget _buildSquareCard(BuildContext context, String title, Widget targetPage, bool isNew) {
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
        child: const Text('baru', style: TextStyle(fontSize: 10, color: Colors.white)),
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
    final sekarang = DateTime.now();
    final sekarangDalamMenit = sekarang.hour * 60 + sekarang.minute;

    int keMenit(String waktu) {
      final bagian = waktu.split(':');
      return int.parse(bagian[0]) * 60 + int.parse(bagian[1]);
    }

    String waktuSholatBerikutnya = prayers['Imsak']!; 
    String namaSholatBerikutnya = 'Imsak';

    if (sekarangDalamMenit < keMenit(prayers['Imsak']!)) {
      waktuSholatBerikutnya = prayers['Imsak']!;
      namaSholatBerikutnya = "Imsak"; 
    } else if (sekarangDalamMenit < keMenit(prayers['subuh']!)) {
      waktuSholatBerikutnya = prayers['subuh']!;
      namaSholatBerikutnya = "Subuh"; 
    } else if (sekarangDalamMenit < keMenit(prayers['Terbit']!)) {
      waktuSholatBerikutnya = prayers['Terbit']!;
      namaSholatBerikutnya = "Terbit"; 
    } else if (sekarangDalamMenit < keMenit(prayers['Dzuhur']!)) {
      waktuSholatBerikutnya = prayers['Dzuhur']!;
      namaSholatBerikutnya = "Dzuhur"; 
    } else if (sekarangDalamMenit < keMenit(prayers['Ashar']!)) {
      waktuSholatBerikutnya = prayers['Ashar']!;
      namaSholatBerikutnya = "Ashar"; 
    } else if (sekarangDalamMenit < keMenit(prayers['Maghrib']!)) {
      waktuSholatBerikutnya = prayers['Maghrib']!;
      namaSholatBerikutnya = "Maghrib";
    } else if (sekarangDalamMenit < keMenit(prayers['Isya']!)) {
      waktuSholatBerikutnya = prayers['Isya']!;
      namaSholatBerikutnya = "Isya"; 
    } else {
      waktuSholatBerikutnya = prayers['Imsak']!;
      namaSholatBerikutnya = "Imsak";
    }
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          color: Colors.teal[900],
          child: Column(
            children: [
              const Text('Jakarta, Indonesia', style: TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 10),
              Text(waktuSholatBerikutnya, style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 5),
              Text(
                "Menuju $namaSholatBerikutnya",
                style: const TextStyle(fontSize: 16, color: Colors.white70, fontStyle: FontStyle.italic),
              )
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
                title: Text(e.key, style: const TextStyle(color: Colors.white)),
                trailing: Text(e.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                leading: const Icon(Icons.notifications_none, color: Colors.teal),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  final bool isDarkMode;
  final bool tampilkanTerjemahan;
  final double skalaFont;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<bool> onTranslationChanged;
  final ValueChanged<double> onFontSizeChanged;

  const ProfilePage({
    super.key,
    required this.isDarkMode,
    required this.tampilkanTerjemahan,
    required this.skalaFont,
    required this.onThemeChanged,
    required this.onTranslationChanged,
    required this.onFontSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final warnaKartu = isDarkMode ? Colors.grey[900] : Colors.grey[100];
    final warnaJudulMenu = isDarkMode ? Colors.teal : Colors.teal[700];
    final warnaTeksUtama = isDarkMode ? Colors.white : Colors.black;
    final warnaTeksSekunder = isDarkMode ? Colors.grey : Colors.grey[700];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(
            'Pengaturan Aplikasi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: warnaJudulMenu),
          ),
        ),
        const SizedBox(height: 10),
        
        Card(
          color: warnaKartu,
          child: SwitchListTile(
            secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.teal),
            title: Text('Mode Gelap', style: TextStyle(color: warnaTeksUtama, fontSize: 16)),
            subtitle: Text(isDarkMode ? 'Aplikasi berwarna hitam' : 'Aplikasi berwarna putih', style: TextStyle(color: warnaTeksSekunder, fontSize: 12)),
            value: isDarkMode,
            activeColor: Colors.teal,
            onChanged: onThemeChanged,
          ),
        ),
        
        Card(
          color: warnaKartu,
          child: SwitchListTile(
            secondary: const Icon(Icons.translate, color: Colors.teal),
            title: Text('Tampilkan Terjemahan', style: TextStyle(color: warnaTeksUtama, fontSize: 16)),
            subtitle: Text(tampilkanTerjemahan ? 'Terjemahan teks ditampilkan' : 'Hanya menampilkan teks Arab', style: TextStyle(color: warnaTeksSekunder, fontSize: 12)),
            value: tampilkanTerjemahan,
            activeColor: Colors.teal,
            onChanged: onTranslationChanged,
          ),
        ),
        
        Card(
          color: warnaKartu,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.format_size, color: Colors.teal),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ukuran Font Bacaan', style: TextStyle(color: warnaTeksUtama, fontSize: 16)),
                          Text('Atur skala besar kecil khusus teks ayat/bacaan', style: TextStyle(color: warnaTeksSekunder, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('A', style: TextStyle(color: warnaTeksUtama, fontSize: 12)),
                    Expanded(
                      child: Slider(
                        value: skalaFont,
                        min: 0.8,
                        max: 1.6,
                        divisions: 4,
                        activeColor: Colors.teal,
                        inactiveColor: isDarkMode ? Colors.grey[800] : Colors.grey[400],
                        label: '${(skalaFont * 100).toInt()}%',
                        onChanged: onFontSizeChanged,
                      ),
                    ),
                    Text('A', style: TextStyle(color: warnaTeksUtama, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),

        Card(
          color: warnaKartu,
          child: ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.teal),
            title: Text('Tentang Aplikasi', style: TextStyle(color: warnaTeksUtama, fontSize: 16)),
            subtitle: Text('Versi 1.0.0', style: TextStyle(color: warnaTeksSekunder, fontSize: 12)),
          ),
        ),
      ],
    );
  }
}
    
class SurahPendekPage extends StatefulWidget {
  final double skalaFont;
  final bool tampilkanTerjemahan;
  final bool isDarkMode;

  const SurahPendekPage({
    super.key,
    required this.skalaFont,
    required this.tampilkanTerjemahan,
    required this.isDarkMode,
  });

  @override
  State<SurahPendekPage> createState() => _SurahPendekPageState();
}

class _SurahPendekPageState extends State<SurahPendekPage> {
  List _daftarSurah = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _ambilDataAlquran();
  }

  Future<void> _ambilDataAlquran() async {
    try {
      final respon = await http.get(Uri.parse('https://equran.id/api/v2/surat'));
      if (respon.statusCode == 200) {
        setState(() {
          _daftarSurah = json.decode(respon.body)['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Al-Qur\'an'),
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : ListView.builder(
              itemCount: _daftarSurah.length,
              itemBuilder: (context, index) {
                final surah = _daftarSurah[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(
                      "${surah['nomor']}", 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(surah['namaLatin'], style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black)),
                  subtitle: Text(
                    "${surah['tempatTurun'].toString().toUpperCase()} • ${surah['jumlahAyat']} Ayat", 
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  trailing: Text(
                    surah['nama'], 
                    style: const TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => HalamanMubarakQuran(
                        nomorSurah: surah['nomor'], 
                        judulSurah: surah['namaLatin'],
                        skalaFont: widget.skalaFont,
                        isDarkMode: widget.isDarkMode,
                      ),
                    ));
                  },
                );
              },
            ),
    );
  }
}

class SholawatPage extends StatelessWidget {
  final double skalaFont;
  final bool tampilkanTerjemahan;
  final bool isDarkMode;

  const SholawatPage({
    super.key,
    required this.skalaFont,
    required this.tampilkanTerjemahan,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> sholawat = [
      "Sholawat Ibrahimiyah",
      "Sholawat Jibril",
      "Sholawat Nariyah",
      "Sholawat Munjiyat",
    ];
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Kumpulan Sholawat'), 
        backgroundColor: isDarkMode ? Colors.black : Colors.teal, 
        foregroundColor: Colors.white
      ),
      body: ListView.builder(
        itemCount: sholawat.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.favorite_border_rounded, color: Colors.teal),
            title: Text(sholawat[index], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 14),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => IsiBacaanPage(
                  judul: sholawat[index],
                  skalaFont: skalaFont,
                  tampilkanTerjemahan: tampilkanTerjemahan,
                  isDarkMode: isDarkMode,
                ),
              ));
            },
          );
        },
      ),
    );
  }
}

class MaulidPage extends StatelessWidget {
  final double skalaFont;
  final bool tampilkanTerjemahan;
  final bool isDarkMode;

  const MaulidPage({
    super.key,
    required this.skalaFont,
    required this.tampilkanTerjemahan,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> maulid = [
      "Maulid Simtutdurar (pembuka)",
      "Qashidah Burdah (Bab 1)",
      "Qashidah Ya Imamarusli",
      "Qashidah Busro Lana",
    ];
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Maulid & Qashidah'), 
        backgroundColor: isDarkMode ? Colors.black : Colors.teal, 
        foregroundColor: Colors.white
      ),
      body: ListView.builder(
        itemCount: maulid.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.wb_sunny_rounded, color: Colors.teal),
            title: Text(maulid[index], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 14),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => IsiBacaanPage(
                  judul: maulid[index],
                  skalaFont: skalaFont,
                  tampilkanTerjemahan: tampilkanTerjemahan,
                  isDarkMode: isDarkMode,
                ),
              ));
            },
          );
        },
      ),
    );
  }
}

class HizibPage extends StatelessWidget {
  final double skalaFont;
  final bool tampilkanTerjemahan;
  final bool isDarkMode;

  const HizibPage({
    super.key,
    required this.skalaFont,
    required this.tampilkanTerjemahan,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> hizib = [
      "Ratib Al-Haddad (Awal)",
      "Ratib Al-Atthas (Awal)",
      "Hizib Nashor (Pembuka)",
      "Hizib Bahar (Pembuka)",
    ];
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Hizib & Ratib'), 
        backgroundColor: isDarkMode ? Colors.black : Colors.teal, 
        foregroundColor: Colors.white
      ),
      body: ListView.builder(
        itemCount: hizib.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.wb_sunny_rounded, color: Colors.teal),
            title: Text(hizib[index], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 14),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => IsiBacaanPage(
                  judul: hizib[index],
                  skalaFont: skalaFont,
                  tampilkanTerjemahan: tampilkanTerjemahan,
                  isDarkMode: isDarkMode,
                ),
              ));
            },
          );
        },
      ),
    );
  }
}
  
class IsiBacaanPage extends StatelessWidget {
  final String judul;
  final double skalaFont;
  final bool tampilkanTerjemahan;
  final bool isDarkMode; // <-- BERHASIL DITAMBAHKAN DI SINI

  const IsiBacaanPage({
    super.key, 
    required this.judul,
    required this.skalaFont,
    required this.tampilkanTerjemahan,
    required this.isDarkMode, // <-- BERHASIL DITAMBAHKAN DI SINI
  });

  @override
  Widget build(BuildContext context) {
    String teksArab = "";
    String artiTeks = "";

    if (judul == "Sholawat Ibrahimiyah") {
      teksArab = "اَللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ  مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ وَبَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ فِي الْعَالَمِينَ إِنَّكَ حَمِيدٌ مَجِيدٌ";
      artiTeks = "Ya Allah, limpahkanlah rahmat kepada Nabi Muhammad dan kepada keluarga Nabi Muhammad, sebagaimana Engkau telah melimpahkan rahmat kepada Nabi Ibrahim dan kepada keluarga Nabi Ibrahim. Dan berkahilah Nabi Muhammad dan keluarga Nabi Muhammad, sebagaimana Engkau telah memberkahi Nabi Ibrahim dan keluarga Nabi Ibrahim. Sesungguhnya di seluruh alam semesta ini, Engkau Maha Terpuji lagi Maha Mulia.";
    }
    else if (judul == "Sholawat Jibril") {
      teksArab = "صَلَّى اللهُ عَلَى مُحَمَّدٍ";
      artiTeks = "Semoga Allah memberikan rahmat-Nya kepada Nabi Muhammad. \n(Sholawat singkat penarik rezeki.)";
    }
    else if (judul == "Sholawat Nariyah") {
      teksArab = "اَللَّهُمَّ صَلِّ صَلَاةً كَامِلَةً وَسَلِّمْ سَلَامًا تَامًّا عَلَى سَيِّدِنَا مُحَمَّدٍ الَّذِي تَنْحَلُّ بِهِ الْعُقَدُ وَتَنْفَرِجُ بِهِ الْكُرَبُ وَتُقْضَى بِهِ الْحَوَائِجُ وَتُنَالُ بِهِ الرَّغَائِبُ وَحُسْنُ الْخَوَاتِمِ وَيُسْتَسْقَى الْغَمَامُ بِوَجْهِهِ الْكَرِيمِ وَعَلَى آلِهِ وَصَحْبِهِ فِي كُلِّ لَمْحَةٍ وَنَفَسٍ بِعَدَدِ كُلِّ مَعْلُومٍ لَكَ";
      artiTeks = "Ya Allah, limpahkanlah shalawat yang sempurna dan kesejahteraan yang paripurna kepada junjungan kami Nabi Muhammad, yang dengan perantaraannya semua ikatan terlepas, segala kesusahan dihilangkan, segala kebutuhan dipenuhi, segala keinginan dan akhir yang baik tercapai, dan hujan diturunkan berkat wajahnya yang mulia. Begitu pula kepada keluarga dan para sahabatnya pada setiap kedipan mata and hembusan nafas, sebanyak jumlah semua yang Engkau ketahui.";
    }
    else if (judul == "Sholawat Munjiyat") {
      teksArab = "اَللَّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ صَلَاةً تُنْجِينَا بِهَا مِنْ جَمِيعِ الْأَهْوَالِ وَالْآفَاتِ وَتَقْضِي لَنَا بِهَا جَمِيعَ الْحَاجَاتِ وَتُطَهِّرُنَا بِهَا مِنْ جَمِيعِ السَّيِّئَاتِ وَتَرْفَعُنَا بِهَا عِنْدَكَ أَعْلَى الدَّرَجَاتِ وَتُبَلِّغُنَا بِهَا أَقْصَى الْغَايَاتِ مِنْ جَمِيعِ الْخَيْرَاتِ فِي الْحَيَاةِ وَبَعْدَ الْمَمَاتِ";
      artiTeks = "Ya Allah, limpahkanlah rahmat kepada junjungan kami Nabi Muhammad, yang dengan shalawat itu Engkau akan menyelamatkan kami dari semua keadaan yang menakutkan dan dari semua malapetaka, Engkau akan memenuhi semua kebutuhan kami, Engkau akan membersihkan kami dari semua keburukan, Engkau akan mengangkat kami ke derajat tertinggi di sisi-Mu, dan Engkau akan menyampaikan kami kepada tujuan yang paling sempurna dari semua kebaikan, baik semasa hidup maupun setelah mati.";
    }
    else if (judul == "Maulid Simtutdurar (pembuka)") {
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
                "وَأَزِ حْ مَا اسْتَطَعْتَ مِنْ عِلَلٍ ❁ عَنْ كَلَامٍ فِيْكَ ذِيْ زَلَلٍ\n"
                "وَانْتَبِهْ مِنْ رَقْدَةِ الْغَفَلِ ❁ وَاحْتَمِ فِيْ جَاهِ ذِيْ الْعِصَمِ (٣)";
      artiTeks = "1. Wahai pemimpin para Rasul, wahai sandaranku! Engkaulah pintu Allah tumpuanku. Maka di dunia dan akhiratku, wahai Rasulullah, peganglah tanganku (bimbinglah aku).\n\n2. Aku bersumpah demi bintang ketika terbenam, tidaklah sama orang yang sehat dengan orang yang sakit. Maka lepaskanlah keterikatan dua alam darimu, kecuali cinta kepada pemimpin bangsa Arab dan ajam (Nabi Muhammad).\n\n3. Dan hilangkanlah sejauh kemampuanmu dari segala cacat, dari perkataan yang menggelincirkanmu. Dan bangunlah dari tidur kelalaian, serta berlindunglah di bawah kemuliaan Nabi yang terjaga dari dosa.";
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
      artiTeks = "1. Kabar gembira bagi kami karena kami telah mencapai cita-cita. Segala kesulitan telah sirna dan kesucian telah datang. Waktu telah menepati janjinya, dan kegembiraan kini telah nyata diumumkan.\n\n2. Wahai jiwa, bahagia lah dengan pertemuan ini! Wahai mata, sejukkanlah pandangan kami! Ini adalah keindahan Al-Musthafa (Nabi pilihan), cahaya-cahayanya telah tampak terang bagi kami.\n\n3. Wahai kota Thaybah (Madinah), apa yang bisa kami katakan? Sedangkan di dalam dirimu telah tinggal sang Rasul. Dan kami semua berharap untuk bisa sampai kepada Muhammad, Nabi kami.\n\n4. Semoga Allah Sang Pencipta melimpahkan sholawat kepadanya setiap malam dan pagi hari, juga kepada keluarganya yang suci lagi mulia, serta para sahabatnya yang merupakan ahli petunjuk.";
    }
    else if (judul == "Ratib Al-Haddad (Awal)") {
      teksArab = "بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ. لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يُحْيِي وَيُمِيتُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ (٣×)";
      artiTeks = "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang. Tidak ada tuhan yang berhak disembah kecuali Allah semata, tidak ada sekutu bagi-Nya. Bagi-Nya kerajaan dan bagi-Nya segala puji. Dia yang menghidupkan dan yang mematikan, dan Dia Maha Kuasa atas segala sesuatu. (Dibaca 3x).";
    }
    else if (judul == "Ratib Al-Atthas (Awal)") {
      teksArab = "أَعُوذُ بِاللَّهِ السَّمِيعِ الْعَلِيمِ مِنَ الشَّيْطَانِ الرَّجِيمِ (٣×) سْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ (٣×)";
      artiTeks = "Aku berlindung kepada Allah Yang Maha Mendengar lagi Maha Mengetahui dari godaan setan yang terkutuk (3x). \n\nDengan nama Allah yang bila disebut, segala sesuatu di bumi dan di langit tidak akan berbahaya, dan Dia Maha Mendengar lagi Maha Mengetahui (3x).";
    }
    else if (judul == "Hizib Nashor (Pembuka)") {
      teksArab = "اَللَّهُمَّ بِسَطْوَةِ جَبَرُوْتِ قَهْرِكَ، وَبِسُرْعَةِ إِغَاثَةِ نَصْرِكَ، وَبِغَيْرَتِكَ لِاِنْتِهَاكِ حُرُمَاتِكَ، وَبِحِمَايَتِكَ لِمَنِ احْتَمَى بِآيَاتِكَ";
      artiTeks = "Ya Allah, dengan kekuatan kekuasaan penaklukan-Mu, dengan kecepatan bantuan pertolongan-Mu, dengan pembelaan-Mu terhadap pelanggaran kehormatan-Mu, dan dengan perlindungan-Mu bagi siapa yang berlindung dengan ayat-ayat-Mu (kami memohon pertolongan-Mu).";
    }
    else if (judul == "Hizib Bahar (Pembuka)") {
      teksArab = "يَا عَلِيُّ يَا عَظِيْمُ يَا حَلِيْمُ يَا عَلِيْمُ أَنْتَ رَبِّيْ وَعِلْمُكَ حَسْبِيْ فَنِعْمَ الرَّبُّ رَبِّيْ وَنِعْمَ الْحَسْبُ حَسْبِيْ";
      artiTeks = "Wahai Yang Maha Tinggi, Wahai Yang Maha Agung, Wahai Yang Maha Penyantun, Wahai Yang Maha Mengetahui. Engkau adalah Tuhanku, dan ilmu-Mu adalah kecukupanku. Maka sebaik-baik Tuhan adalah Tuhanku, dan sebaik-baik kecukupan adalah kecukupanku.";
    }

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: isDarkMode ? Colors.black : Colors.teal, 
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teksArab,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 26 * skalaFont,
                      height: 2.2,
                      fontFamily: 'Serif',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  if (tampilkanTerjemahan) ...[
                    const Divider(color: Colors.teal, height: 30),
                    Text(
                      artiTeks,
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.grey[800],
                        fontSize: 15 * skalaFont,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HalamanMubarakQuran extends StatefulWidget {
  final int nomorSurah;
  final String judulSurah;
  final double skalaFont;
  final bool isDarkMode; // Meneruskan data warna ke detail Quran

  const HalamanMubarakQuran({
    super.key,
    required this.nomorSurah,
    required this.judulSurah,
    required this.skalaFont,
    required this.isDarkMode,
  });

  @override
  State<HalamanMubarakQuran> createState() => _HalamanMubarakQuranState();
}

class _HalamanMubarakQuranState extends State<HalamanMubarakQuran> {
  Map<String, dynamic>? _detailSurah;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _ambilDetailSurah();
  }

  Future<void> _ambilDetailSurah() async {
    try {
      final respon = await http.get(Uri.parse('https://equran.id/api/v2/surat/${widget.nomorSurah}'));
      if (respon.statusCode == 200) {
        setState(() {
          _detailSurah = json.decode(respon.body)['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _ambilGabunganAyat() {
    if (_detailSurah == null || _detailSurah!['ayat'] == null) return "";
    String totalTeks = "";
    for (var ayat in _detailSurah!['ayat']) {
      totalTeks += "${ayat['teksArab']} ﴿${ayat['nomorAyat']}﴾ ";
    }
    return totalTeks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.teal,
        foregroundColor: Colors.white,
        title: Text(_detailSurah != null ? "${_detailSurah!['namaLatin']}" : widget.judulSurah),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Text(
                      _ambilGabunganAyat(),
                      textDirection: TextDirection.rtl, 
                      textAlign: TextAlign.justify,     
                      style: TextStyle(
                        fontSize: 26 * widget.skalaFont, 
                        height: 2.4,        
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}