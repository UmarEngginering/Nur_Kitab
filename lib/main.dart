import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🟢 Wajib untuk membaca/menyimpan memori
import 'package:nur_kitab/services/notification_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'juz_data.dart';
import 'package:visibility_detector/visibility_detector.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const NurKitabApp());
}

class NurKitabColors {
  static const deepGreen = Color(0xFF002211);
  static const cardGreen = Color(0xFF061A12);
  static const cardGreenLight = Color(0xFF0A2418);
  static const gold = Color(0xFFD4AF37);
  static const goldDim = Color(0xFF8B7340);
  static const navBackground = Color(0xFF001A0D);
  static const textMuted = Color(0xFF9E9E9E);
}

class NurKitabAssets {
  static const archFrame = 'asset/images/arch_frame.png';
  static const lantern = 'asset/images/lantern.png';
  static const crescentMoon = 'asset/images/crescent_moon.png';
  static const quranContinue = 'asset/images/quran_continue.png';
  static const iconQuran = 'asset/images/icon_quran.png';
  static const iconSholawat = 'asset/images/icon_sholawat.png';
  static const iconYasin = 'asset/images/icon_yasin.png';
  static const iconHizib = 'asset/images/icon_hizib.png';
  static const mosqueDome = 'asset/images/mosque_dome.png';
}

Widget nurKitabAsset(
  String path, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.contain,
  Color? color,
  Alignment alignment = Alignment.center,
}) {
  return Image.asset(
    path,
    width: width,
    height: height,
    fit: fit,
    alignment: alignment,
    filterQuality: FilterQuality.high,
    color: color,
    colorBlendMode: color != null ? BlendMode.srcIn : null,
    gaplessPlayback: true,
    errorBuilder: (context, error, stackTrace) => Icon(
      Icons.image_not_supported_outlined,
      size: width ?? height ?? 24,
      color: NurKitabColors.gold,
    ),
  );
}

class NurKitabApp extends StatelessWidget {
  const NurKitabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nur Kitab',
      theme: ThemeData.dark().copyWith(
        primaryColor: NurKitabColors.deepGreen,
        scaffoldBackgroundColor: NurKitabColors.deepGreen,
        colorScheme: const ColorScheme.dark(
          primary: NurKitabColors.gold,
          secondary: NurKitabColors.gold,
          surface: NurKitabColors.cardGreen,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: NurKitabColors.deepGreen,
          foregroundColor: NurKitabColors.gold,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

AppBar nurKitabAppBar(String title) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        color: NurKitabColors.gold,
        fontWeight: FontWeight.w600,
      ),
    ),
    backgroundColor: NurKitabColors.deepGreen,
    foregroundColor: NurKitabColors.gold,
    iconTheme: const IconThemeData(color: NurKitabColors.gold),
    elevation: 0,
  );
}

BoxDecoration nurKitabCardDecoration({double radius = 16}) {
  return BoxDecoration(
    color: NurKitabColors.cardGreen.withValues(alpha: 0.92),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: NurKitabColors.gold.withValues(alpha: 0.45),
      width: 1,
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isDarkMode = false;
  double skalaFont = 1.0;
  bool isAdzanEnabled = true;
  String adzanSound = 'Adzan Kurdi Syeikh Mishary Rashid Al-Afasy 1';

  @override
  void initState() {
    super.initState();
    _muatPengaturan();
  }

  Future<void> _muatPengaturan() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      skalaFont = prefs.getDouble('skalaFont') ?? 1.0;
      isAdzanEnabled = prefs.getBool('isAdzanEnabled') ?? true;
      adzanSound = prefs.getString('adzanSound') ?? 'Adzan Kurdi Syeikh Mishary Rashid Al-Afasy 1';
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeContent(
        skalaFont: skalaFont,
        isDarkMode: isDarkMode,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onMoonTap: () async {
          final newValue = !isDarkMode;
          setState(() => isDarkMode = newValue);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isDarkMode', newValue);
        },
      ),
      const PrayerSchedulePage(),
      ProfilePage(
        isDarkMode: isDarkMode,
        skalaFont: skalaFont,
        onThemeChanged: (nilai) async {
          setState(() => isDarkMode = nilai);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isDarkMode', nilai);
        },
        onFontSizeChanged: (nilai) async {
          setState(() => skalaFont = nilai);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setDouble('skalaFont', nilai);
        },
        isAdzanEnabled: isAdzanEnabled,
        adzanSound: adzanSound,
        onAdzanChanged: (nilai) async {
          setState(() => isAdzanEnabled = nilai);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isAdzanEnabled', nilai);
        },
        onAdzanSoundChanged: (nilai) async {
          setState(() => adzanSound = nilai);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('adzanSound', nilai);
        },
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: NurKitabColors.deepGreen,
      drawer: _buildDrawer(),
      body: pages[currentIndex],
      bottomNavigationBar: _NurKitabBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TasbihPage()),
                );
              },
              backgroundColor: NurKitabColors.gold,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.fingerprint,
                color: NurKitabColors.deepGreen,
                size: 28,
              ),
            )
          : null,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: NurKitabColors.cardGreen,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  nurKitabAsset(
                    NurKitabAssets.archFrame,
                    width: 48,
                    height: 56,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Nur Kitab',
                    style: TextStyle(
                      color: NurKitabColors.gold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: NurKitabColors.goldDim),
            ListTile(
              leading: const Icon(
                Icons.home_rounded,
                color: NurKitabColors.gold,
              ),
              title: const Text(
                'Beranda',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() => currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.calendar_month_outlined,
                color: NurKitabColors.gold,
              ),
              title: const Text(
                'Jadwal Sholat',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() => currentIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
                color: NurKitabColors.gold,
              ),
              title: const Text(
                'Pengaturan',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() => currentIndex = 2);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NurKitabBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NurKitabBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NurKitabColors.navBackground,
        border: Border(
          top: BorderSide(color: NurKitabColors.gold.withValues(alpha: 0.15)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(0, Icons.home_rounded, 'Beranda'),
              _item(1, Icons.calendar_month_outlined, 'Jadwal'),
              _item(2, Icons.settings_outlined, 'Pengaturan'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(int index, IconData icon, String label) {
    final active = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 88,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: active
                  ? BoxDecoration(
                      color: NurKitabColors.gold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: NurKitabColors.gold.withValues(alpha: 0.25),
                          blurRadius: 12,
                        ),
                      ],
                    )
                  : null,
              child: Icon(
                icon,
                color: active ? NurKitabColors.gold : NurKitabColors.textMuted,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: active ? NurKitabColors.gold : NurKitabColors.textMuted,
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final double skalaFont;
  final bool isDarkMode;
  final VoidCallback onMenuTap;
  final VoidCallback onMoonTap;

  const HomeContent({
    super.key,
    required this.skalaFont,
    required this.isDarkMode,
    required this.onMenuTap,
    required this.onMoonTap,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _lastReadType = 'surah'; // 'surah' or 'juz'
  int _lastSurahNomor = 18; // Default awal jika memori kosong: Al-Kahfi
  String _lastSurahNama = 'Al-Kahfi';
  int _lastJuzNomor = 1;
  String _lastJuzSubtitle = '';

  @override
  void initState() {
    super.initState();
    _muatBacaanTerakhir();
  }

  // Fungsi untuk menarik data dari memori penyimpanan lokal HP
  Future<void> _muatBacaanTerakhir() async {
    final prefs = await SharedPreferences.getInstance();
    
    String lastReadType = prefs.getString('last_read_type') ?? 'surah';
    int lastSurahNomor = prefs.getInt('last_surah_nomor') ?? 18;
    String lastSurahNama = prefs.getString('last_surah_nama') ?? 'Al-Kahfi';
    int lastJuzNomor = prefs.getInt('last_juz_nomor') ?? 1;
    String lastJuzSubtitle = 'Lanjutkan Juz $lastJuzNomor';

    if (lastReadType == 'juz') {
      String? savedJuzSurah = prefs.getString('last_juz_surah');
      if (savedJuzSurah != null && savedJuzSurah.isNotEmpty) {
        lastJuzSubtitle = savedJuzSurah;
      } else {
        try {
          final juzInfo = juzMapping.firstWhere((j) => j['juz'] == lastJuzNomor, orElse: () => juzMapping[0]);
          final String surahMetadataJson = await rootBundle.loadString('asset/json/surah.json');
          final Map<String, dynamic> allSurah = json.decode(surahMetadataJson);
          final List<dynamic> listSurah = allSurah['data'] ?? [];
          
          final startSurah = listSurah.firstWhere((s) => s['id'] == juzInfo['start_sura'], orElse: () => null);
          
          String startName = startSurah != null ? (startSurah['namaLatin'] ?? startSurah['surat_name'] ?? '') : '';
          
          lastJuzSubtitle = startName.isNotEmpty ? startName : 'Lanjutkan Juz $lastJuzNomor';
        } catch (e) {
          // ignore
        }
      }
    }

    setState(() {
      _lastReadType = lastReadType;
      _lastSurahNomor = lastSurahNomor;
      _lastSurahNama = lastSurahNama;
      _lastJuzNomor = lastJuzNomor;
      _lastJuzSubtitle = lastJuzSubtitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF003320),
            NurKitabColors.deepGreen,
            Color(0xFF001408),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0A3020).withValues(alpha: 0.9),
                    NurKitabColors.deepGreen,
                    const Color(0xFF001408),
                  ],
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Opacity(
                      opacity: 0.22,
                      child: nurKitabAsset(
                        NurKitabAssets.mosqueDome,
                        height: 160,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 24,
                    left: 8,
                    child: Opacity(
                      opacity: 0.45,
                      child: nurKitabAsset(
                        NurKitabAssets.lantern,
                        width: 56,
                        height: 90,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 24,
                    right: 8,
                    child: Opacity(
                      opacity: 0.45,
                      child: nurKitabAsset(
                        NurKitabAssets.lantern,
                        width: 56,
                        height: 90,
                      ),
                    ),
                  ),
                  CustomPaint(painter: _MosqueGlowPainter()),
                ],
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _buildTopBar(),
                const SizedBox(height: 12),
                _buildBranding(),
                const SizedBox(height: 20),
                _buildGreeting(),
                const SizedBox(height: 24),
                _buildContinueCard(context), // Kartu Lanjutkan dinamis
                const SizedBox(height: 20),
                _buildMenuGrid(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: widget.onMenuTap,
          icon: const Icon(
            Icons.menu_rounded,
            color: NurKitabColors.gold,
            size: 28,
          ),
        ),
        IconButton(
          onPressed: widget.onMoonTap,
          padding: EdgeInsets.zero,
          icon: Icon(
            widget.isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined,
            color: NurKitabColors.gold,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildBranding() {
    return Column(
      children: [
        SizedBox(
          width: 88,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              nurKitabAsset(
                NurKitabAssets.archFrame,
                width: 88,
                height: 100,
                fit: BoxFit.contain,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  'الله',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 26,
                    color: NurKitabColors.gold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Nur Kitab',
          style: TextStyle(
            fontFamily: 'Serif',
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: NurKitabColors.gold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.diamond,
              size: 8,
              color: NurKitabColors.gold.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Text(
              'cahaya ilmu, penuntun hati',
              style: TextStyle(
                color: NurKitabColors.gold.withValues(alpha: 0.85),
                fontSize: 12,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.diamond,
              size: 8,
              color: NurKitabColors.gold.withValues(alpha: 0.7),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: NurKitabColors.gold.withValues(alpha: 0.35),
                thickness: 0.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.auto_awesome,
                size: 12,
                color: NurKitabColors.gold.withValues(alpha: 0.5),
              ),
            ),
            Expanded(
              child: Divider(
                color: NurKitabColors.gold.withValues(alpha: 0.35),
                thickness: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Column(
      children: [
        const Text(
          "Assalamu'alaikum",
          style: TextStyle(
            fontFamily: 'Serif',
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Semoga harimu penuh berkah dan diliputi cahaya iman.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueCard(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: nurKitabCardDecoration(radius: 20),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: NurKitabColors.gold.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: nurKitabAsset(
                    NurKitabAssets.quranContinue,
                    width: 68,
                    height: 68,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LANJUTKAN BACAAN TERAKHIR AL-QURAN',
                      style: TextStyle(
                        color: NurKitabColors.gold.withValues(alpha: 0.85),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _lastReadType == 'juz' ? "Juz $_lastJuzNomor" : _lastSurahNama, // 🟢 Dinamis mengikuti data memori lokal
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _lastReadType == 'juz' ? _lastJuzSubtitle : 'Surat Ke-$_lastSurahNomor', // 🟢 Menampilkan urutan nomor surah dinamis
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: NurKitabColors.gold,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    // 🟢 Membuka surah atau juz terakhir yang terekam
                    if (_lastReadType == 'juz') {
                      final juzInfo = juzMapping.firstWhere((j) => j['juz'] == _lastJuzNomor, orElse: () => juzMapping[0]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HalamanMubarakJuz(
                            juzInfo: juzInfo,
                            skalaFont: widget.skalaFont,
                            isDarkMode: widget.isDarkMode,
                          ),
                        ),
                      ).then(
                        (_) => _muatBacaanTerakhir(),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HalamanMubarakQuran(
                            nomorSurah: _lastSurahNomor,
                            judulSurah: _lastSurahNama,
                            skalaFont: widget.skalaFont,
                            isDarkMode: widget.isDarkMode,
                          ),
                        ),
                      ).then(
                        (_) => _muatBacaanTerakhir(),
                      ); // 🟢 Refresh data saat user kembali ke Beranda
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(width: 2),
                        Text(
                          'Lanjutkan',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -6,
          left: 20,
          child: Icon(
            Icons.bookmark,
            color: NurKitabColors.gold.withValues(alpha: 0.9),
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final items = [
      _MenuItem(
        title: "Al-Qur'an",
        description: 'Baca, pahami, dan renungi firman Allah setiap hari.',
        imageAsset: NurKitabAssets.iconQuran,
        page: SurahPendekPage(
          skalaFont: widget.skalaFont,
          isDarkMode: widget.isDarkMode,
        ),
      ),
      _MenuItem(
        title: 'Sholawat, Maulid & Qashidah',
        description:
            'Kumpulan sholawat pilihan, maulid, dan qashidah yang indah penuh makna.',
        imageAsset: NurKitabAssets.iconSholawat,
        page: SholawatMaulidPage(
          skalaFont: widget.skalaFont,
          isDarkMode: widget.isDarkMode,
        ),
      ),
      _MenuItem(
        title: 'Yasin & Tahlil',
        description:
            'Bacaan Yasin dan tahlil untuk mendoakan dan mengingat ahli kubur.',
        imageAsset: NurKitabAssets.iconYasin,
        page: YasinTahlilPage(
          skalaFont: widget.skalaFont,
          isDarkMode: widget.isDarkMode,
        ),
      ),
      _MenuItem(
        title: 'Hizib & Ratib',
        description:
            'Kumpulan hizib dan ratib harian untuk wirid dan penjagaan diri.',
        imageAsset: NurKitabAssets.iconHizib,
        page: HizibPage(
          skalaFont: widget.skalaFont,
          isDarkMode: widget.isDarkMode,
        ),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.74,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildGridCard(context, items[index]),
    );
  }

  Widget _buildGridCard(BuildContext context, _MenuItem item) {
    return GestureDetector(
      // 🟢 Ditambahkan .then(...) agar ketika masuk menu Quran lalu kembali, data kartu langsung terrefrsh dinamis
      onTap: () =>
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item.page),
          ).then((_) {
            _muatBacaanTerakhir();
          }),
      child: Container(
        decoration: nurKitabCardDecoration(radius: 16).copyWith(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              NurKitabColors.cardGreenLight,
              NurKitabColors.cardGreen.withValues(alpha: 0.95),
            ],
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.40,
                    child: Center(
                      child: nurKitabAsset(
                        item.imageAsset,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: NurKitabColors.gold,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      item.description,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 10,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: NurKitabColors.gold.withValues(alpha: 0.5),
                          width: 1.2,
                        ),
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: NurKitabColors.gold,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final String description;
  final String imageAsset;
  final Widget page;

  const _MenuItem({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.page,
  });
}

class _MosqueGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.12);
    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              NurKitabColors.gold.withValues(alpha: 0.12),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(center: center, radius: size.width * 0.45),
          );
    canvas.drawCircle(center, size.width * 0.45, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PrayerSchedulePage extends StatefulWidget {
  const PrayerSchedulePage({super.key});

  @override
  State<PrayerSchedulePage> createState() => _PrayerSchedulePageState();
}

class _PrayerSchedulePageState extends State<PrayerSchedulePage> {
  Map<String, String> _prayers = {};
  bool _isLoading = true;
  String _namaLokasi = "Mencari lokasi...";
  String _errorMsg = "";

  Timer? _timer;
  String _waktuSekarang = "";
  String _tanggalMasehi = "";
  String _tanggalHijriyah = "";

  @override
  void initState() {
    super.initState();
    _waktuSekarang = _formatWaktu(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          _waktuSekarang = _formatWaktu(DateTime.now());
        });
      }
    });
    _dapatkanLokasiDanJadwal();
  }

  String _formatWaktu(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _dapatkanLokasiDanJadwal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLat = prefs.getDouble('jadwal_lat');
      final savedLng = prefs.getDouble('jadwal_lng');
      final savedNama = prefs.getString('jadwal_nama_kota');

      if (savedLat != null && savedLng != null && savedNama != null) {
        await _ambilJadwalSholat(lat: savedLat, lng: savedLng, nama: savedNama);
      } else {
        await _simpanLokasiDanAmbilJadwal(
          -7.1561,
          113.4812,
          "Kabupaten Pamekasan",
        );
      }
    } catch (e) {
      setState(() {
        _errorMsg = "Gagal memuat lokasi harian.";
        _isLoading = false;
      });
    }
  }

  Future<void> _cariLokasiGPSTerbaru() async {
    setState(() {
      _isLoading = true;
      _errorMsg = "";
      _namaLokasi = "Mencari lokasi terbaru...";
    });
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _simpanLokasiDanAmbilJadwal(
          -7.1561,
          113.4812,
          "Pamekasan (Default - GPS Mati)",
        );
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          await _simpanLokasiDanAmbilJadwal(
            -7.1561,
            113.4812,
            "Pamekasan (Default - Izin Ditolak)",
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await _simpanLokasiDanAmbilJadwal(
          -7.1561,
          113.4812,
          "Pamekasan (Default - Izin Diblokir)",
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      String namaKotaDinamis = "Lokasi Anda";
      try {
        final urlGeo =
            'https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}&lon=${position.longitude}&format=json&accept-language=id';

        final responGeo = await http.get(
          Uri.parse(urlGeo),
          headers: {'User-Agent': 'NurKitabApp/1.0'},
        );

        if (responGeo.statusCode == 200) {
          final dataGeo = json.decode(responGeo.body);
          final address = dataGeo['address'];
          if (address != null) {
            String desa = address['village'] ?? address['suburb'] ?? address['neighbourhood'] ?? address['hamlet'] ?? '';
            String kecamatan = address['city_district'] ?? address['district'] ?? address['municipality'] ?? '';
            String kabupaten = address['county'] ?? address['city'] ?? address['regency'] ?? address['town'] ?? '';
            
            List<String> parts = [];
            if (desa.isNotEmpty) parts.add(desa);
            if (kecamatan.isNotEmpty) parts.add(kecamatan);
            if (parts.isEmpty && kabupaten.isNotEmpty) parts.add(kabupaten);

            if (parts.isNotEmpty) {
              namaKotaDinamis = parts.join(", ");
            } else {
              namaKotaDinamis = "Lokasi Anda";
            }
          }
        }
      } catch (e) {
        namaKotaDinamis =
            "Lokasi Anda (${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)})";
      }

      await _simpanLokasiDanAmbilJadwal(
        position.latitude,
        position.longitude,
        namaKotaDinamis,
      );
    } catch (e) {
      setState(() {
        _errorMsg = "Gagal memuat lokasi harian.";
        _isLoading = false;
      });
    }
  }

  Future<void> _simpanLokasiDanAmbilJadwal(
    double lat,
    double lng,
    String nama,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('jadwal_lat', lat);
    await prefs.setDouble('jadwal_lng', lng);
    await prefs.setString('jadwal_nama_kota', nama);
    await _ambilJadwalSholat(lat: lat, lng: lng, nama: nama);
  }

  Future<void> _ambilJadwalSholat({
    required double lat,
    required double lng,
    required String nama,
  }) async {
    try {
      final sekarang = DateTime.now();
      final prefs = await SharedPreferences.getInstance();

      final url =
          'https://api.aladhan.com/v1/calendar/${sekarang.year}/${sekarang.month}?latitude=$lat&longitude=$lng&method=20';

      Map<String, dynamic>? dataJsonBulanIni;
      
      try {
        final respon = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
        if (respon.statusCode == 200) {
          await prefs.setString('jadwal_bulanan_cache', respon.body);
          dataJsonBulanIni = json.decode(respon.body);
        }
      } catch (_) {}

      if (dataJsonBulanIni == null) {
        final cachedData = prefs.getString('jadwal_bulanan_cache');
        if (cachedData != null) {
          dataJsonBulanIni = json.decode(cachedData);
        } else {
          throw Exception("Tidak ada cache jadwal offline.");
        }
      }

      final List<dynamic> dataDays = dataJsonBulanIni!['data'];
      final dataHariIni = dataDays.firstWhere(
        (day) => day['date']['gregorian']['day'] == sekarang.day.toString().padLeft(2, '0'),
        orElse: () => dataDays.first,
      );
      
      final dataTimings = dataHariIni['timings'];
      final dateInfo = dataHariIni['date'];

      setState(() {
        _tanggalMasehi = dateInfo['readable'] ?? '';
        if (dateInfo['hijri'] != null) {
          final hijri = dateInfo['hijri'];
          _tanggalHijriyah =
              "${hijri['day']} ${hijri['month']['en']} ${hijri['year']} H";
        }

        String cleanTime(String time) => time.split(' ')[0];

        _prayers = {
          'Imsak': cleanTime(dataTimings['Imsak'] ?? '00:00'),
          'Subuh': cleanTime(dataTimings['Fajr'] ?? '00:00'),
          'Terbit': cleanTime(dataTimings['Sunrise'] ?? '00:00'),
          'Dzuhur': cleanTime(dataTimings['Dhuhr'] ?? '00:00'),
          'Ashar': cleanTime(dataTimings['Asr'] ?? '00:00'),
          'Maghrib': cleanTime(dataTimings['Maghrib'] ?? '00:00'),
          'Isya': cleanTime(dataTimings['Isha'] ?? '00:00'),
        };
        _namaLokasi = nama;
        _isLoading = false;
      });

      // --- Penjadwalan Notifikasi Adzan (Offline & 7 Hari Kedepan) ---
      final bool isAdzanEnabled = prefs.getBool('isAdzanEnabled') ?? true;
      final String adzanSound = prefs.getString('adzanSound') ?? 'Adzan Kurdi Syeikh Mishary Rashid Al-Afasy 1';

      if (isAdzanEnabled) {
        await NotificationService.cancelAllNotifications();
        int idCounter = 0;
        final sholatNames = ['Subuh', 'Dzuhur', 'Ashar', 'Maghrib', 'Isya'];
        final timingKeys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

        int currentDayIdx = sekarang.day - 1; 
        int maxDays = 7;
        for (int i = 0; i < maxDays; i++) {
          if (currentDayIdx + i >= dataDays.length) break;
          
          final targetDayData = dataDays[currentDayIdx + i];
          final tDayStr = targetDayData['date']['gregorian']['day'];
          final int tDay = int.parse(tDayStr);
          final targetTimings = targetDayData['timings'];
          
          for (int s = 0; s < sholatNames.length; s++) {
            String timeStr = targetTimings[timingKeys[s]] ?? '';
            if (timeStr.isNotEmpty) {
              timeStr = timeStr.split(' ')[0];
              final timeParts = timeStr.split(':');
              final hour = int.parse(timeParts[0]);
              final minute = int.parse(timeParts[1]);

              final scheduleTime = DateTime(
                sekarang.year,
                sekarang.month,
                tDay,
                hour,
                minute,
              );
              
              if (scheduleTime.isAfter(DateTime.now())) {
                await NotificationService.schedulePrayerNotification(
                  id: idCounter++,
                  title: 'Waktu ${sholatNames[s]}',
                  body: 'Telah masuk waktu sholat ${sholatNames[s]} untuk $_namaLokasi.',
                  scheduledTime: scheduleTime,
                  soundType: adzanSound,
                );
              }
            }
          }
        }
      }
    } catch (e) {
      setState(() {
        _errorMsg = "Gagal mengambil data jadwal sholat.";
        _isLoading = false;
      });
    }
  }

  int _keMenit(String waktu) {
    final bagian = waktu.split(':');
    return int.parse(bagian[0]) * 60 + int.parse(bagian[1]);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: NurKitabColors.deepGreen,
        body: Center(
          child: CircularProgressIndicator(color: NurKitabColors.gold),
        ),
      );
    }

    if (_errorMsg.isNotEmpty && _prayers.isEmpty) {
      return Scaffold(
        backgroundColor: NurKitabColors.deepGreen,
        body: Center(
          child: Text(_errorMsg, style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    final sekarang = DateTime.now();
    final sekarangDalamMenit = sekarang.hour * 60 + sekarang.minute;

    String waktuSholatBerikutnya = _prayers['Imsak']!;
    String namaSholatBerikutnya = 'Imsak';

    if (sekarangDalamMenit < _keMenit(_prayers['Imsak']!)) {
      waktuSholatBerikutnya = _prayers['Imsak']!;
      namaSholatBerikutnya = "Imsak";
    } else if (sekarangDalamMenit < _keMenit(_prayers['Subuh']!)) {
      waktuSholatBerikutnya = _prayers['Subuh']!;
      namaSholatBerikutnya = "Subuh";
    } else if (sekarangDalamMenit < _keMenit(_prayers['Terbit']!)) {
      waktuSholatBerikutnya = _prayers['Terbit']!;
      namaSholatBerikutnya = "Terbit";
    } else if (sekarangDalamMenit < _keMenit(_prayers['Dzuhur']!)) {
      waktuSholatBerikutnya = _prayers['Dzuhur']!;
      namaSholatBerikutnya = "Dzuhur";
    } else if (sekarangDalamMenit < _keMenit(_prayers['Ashar']!)) {
      waktuSholatBerikutnya = _prayers['Ashar']!;
      namaSholatBerikutnya = "Ashar";
    } else if (sekarangDalamMenit < _keMenit(_prayers['Maghrib']!)) {
      waktuSholatBerikutnya = _prayers['Maghrib']!;
      namaSholatBerikutnya = "Maghrib";
    } else if (sekarangDalamMenit < _keMenit(_prayers['Isya']!)) {
      waktuSholatBerikutnya = _prayers['Isya']!;
      namaSholatBerikutnya = "Isya";
    } else {
      waktuSholatBerikutnya = _prayers['Imsak']!;
      namaSholatBerikutnya = "Imsak (Besok)";
    }

    int targetHour = int.parse(waktuSholatBerikutnya.split(':')[0]);
    int targetMinute = int.parse(waktuSholatBerikutnya.split(':')[1]);
    DateTime targetTime = DateTime(sekarang.year, sekarang.month, sekarang.day, targetHour, targetMinute, 0);
    if (namaSholatBerikutnya.contains('Besok')) {
      targetTime = targetTime.add(const Duration(days: 1));
    }
    Duration diff = targetTime.difference(sekarang);
    if (diff.isNegative) diff = const Duration(seconds: 0);
    String countdownStr = "- ${diff.inHours.toString().padLeft(2, '0')} : ${(diff.inMinutes % 60).toString().padLeft(2, '0')} : ${(diff.inSeconds % 60).toString().padLeft(2, '0')}";

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003320), NurKitabColors.deepGreen],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 24, left: 20, right: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  NurKitabColors.cardGreenLight,
                  NurKitabColors.deepGreen,
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: NurKitabColors.gold.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: NurKitabColors.gold,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "Lokasi Anda",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: _cariLokasiGPSTerbaru,
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.refresh,
                              color: NurKitabColors.gold,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _namaLokasi,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _waktuSekarang,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                if (_tanggalHijriyah.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$_tanggalHijriyah • $_tanggalMasehi",
                        style: TextStyle(
                          fontSize: 13,
                          color: NurKitabColors.gold.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  IslamicCalendarPage(namaLokasi: _namaLokasi),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: NurKitabColors.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.calendar_month_outlined,
                            color: NurKitabColors.gold,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: NurKitabColors.cardGreen.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: NurKitabColors.gold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        countdownStr,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: NurKitabColors.gold,
                        ),
                      ),
                      Text(
                        "Menuju $namaSholatBerikutnya",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _prayers.entries.map((e) {
                final isNext =
                    e.key.toLowerCase() ==
                    namaSholatBerikutnya.toLowerCase().replaceAll(
                      ' (besok)',
                      '',
                    );
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: nurKitabCardDecoration(radius: 12).copyWith(
                    border: Border.all(
                      color: isNext
                          ? NurKitabColors.gold.withValues(alpha: 0.6)
                          : NurKitabColors.gold.withValues(alpha: 0.2),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      e.key,
                      style: TextStyle(
                        color: isNext ? NurKitabColors.gold : Colors.white,
                        fontWeight: isNext
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: Text(
                      e.value,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isNext ? NurKitabColors.gold : Colors.white70,
                      ),
                    ),
                    leading: Icon(
                      isNext
                          ? Icons.notifications_active
                          : Icons.notifications_none,
                      color: isNext
                          ? NurKitabColors.gold
                          : NurKitabColors.goldDim,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final double skalaFont;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<double> onFontSizeChanged;

  final bool isAdzanEnabled;
  final String adzanSound;
  final ValueChanged<bool> onAdzanChanged;
  final ValueChanged<String> onAdzanSoundChanged;

  const ProfilePage({
    super.key,
    required this.isDarkMode,
    required this.skalaFont,
    required this.onThemeChanged,
    required this.onFontSizeChanged,
    required this.isAdzanEnabled,
    required this.adzanSound,
    required this.onAdzanChanged,
    required this.onAdzanSoundChanged,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayAdzan() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      if (widget.adzanSound == 'Standar') return;
      
      // audioplayers versi 6 akan selalu menambahkan 'assets/' di depan file.
      // Karena flutter meng-compile folder 'asset' kita menjadi key yang persis,
      // kita harus menghapus prefix default tersebut agar jalan di HP.
      AudioCache.instance.prefix = '';
      
      String assetPath = 'asset/audio/adzan_mishary_1.mp3';
      if (widget.adzanSound == 'Adzan Kurdi Syeikh Mishary Rashid Al-Afasy 2') {
        assetPath = 'asset/audio/adzan_mishary_2.mp3';
      }
      
      try {
        await _audioPlayer.play(AssetSource(assetPath));
        if (mounted) setState(() => _isPlaying = true);
        
        _audioPlayer.onPlayerComplete.listen((event) {
          if (mounted) setState(() => _isPlaying = false);
        });
      } catch (e) {
        debugPrint("Error playing audio: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003320), NurKitabColors.deepGreen],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Text(
              'Pengaturan Aplikasi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: NurKitabColors.gold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _settingsCard(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Jadwal Sholat & Notifikasi',
                    style: TextStyle(
                      color: NurKitabColors.goldDim,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(
                    Icons.notifications_active,
                    color: NurKitabColors.gold,
                  ),
                  title: const Text(
                    'Notifikasi Adzan',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  subtitle: const Text(
                    'Bunyikan adzan saat waktu sholat',
                    style: TextStyle(
                      color: NurKitabColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  value: widget.isAdzanEnabled,
                  activeThumbColor: NurKitabColors.gold,
                  onChanged: widget.onAdzanChanged,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: widget.adzanSound,
                    decoration: const InputDecoration(
                      labelText: 'Suara Adzan',
                      labelStyle: TextStyle(color: NurKitabColors.goldDim),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: NurKitabColors.goldDim),
                      ),
                    ),
                    dropdownColor: NurKitabColors.cardGreen,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    items: [
                      'Standar',
                      'Adzan Kurdi Syeikh Mishary Rashid Al-Afasy 1',
                      'Adzan Kurdi Syeikh Mishary Rashid Al-Afasy 2'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                         if (_isPlaying) _togglePlayAdzan(); // stop if playing
                         widget.onAdzanSoundChanged(val);
                      }
                    },
                  ),
                      ),
                      if (widget.adzanSound != 'Standar')
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.stop_circle : Icons.play_circle_fill,
                            color: NurKitabColors.gold,
                            size: 32,
                          ),
                          onPressed: _togglePlayAdzan,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          _settingsCard(
            SwitchListTile(
              secondary: Icon(
                widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: NurKitabColors.gold,
              ),
              title: const Text(
                'Mode Gelap',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              subtitle: Text(
                widget.isDarkMode ? 'Tema gelap islami premium' : 'Tema terang',
                style: const TextStyle(
                  color: NurKitabColors.textMuted,
                  fontSize: 12,
                ),
              ),
              value: widget.isDarkMode,
              activeThumbColor: NurKitabColors.gold,
              onChanged: widget.onThemeChanged,
            ),
          ),

          _settingsCard(
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.format_size, color: NurKitabColors.gold),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ukuran Font Bacaan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Atur skala besar kecil khusus teks ayat/bacaan',
                              style: TextStyle(
                                color: NurKitabColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'A',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Expanded(
                        child: Slider(
                          value: widget.skalaFont,
                          min: 0.8,
                          max: 1.6,
                          divisions: 4,
                          activeColor: NurKitabColors.gold,
                          inactiveColor: NurKitabColors.goldDim.withValues(
                            alpha: 0.4,
                          ),
                          label: '${(widget.skalaFont * 100).toInt()}%',
                          onChanged: widget.onFontSizeChanged,
                        ),
                      ),
                      const Text(
                        'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _settingsCard(
            const ListTile(
              leading: Icon(Icons.info_outline, color: NurKitabColors.gold),
              title: Text(
                'Tentang Aplikasi',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              subtitle: Text(
                'Versi 1.0.0',
                style: TextStyle(color: NurKitabColors.textMuted, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsCard(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: nurKitabCardDecoration(radius: 14),
      child: child,
    );
  }
}

class SholawatMaulidPage extends StatelessWidget {
  final double skalaFont;
  final bool isDarkMode;

  const SholawatMaulidPage({
    super.key,
    required this.skalaFont,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      (
        'Sholawat',
        const [
          'Sholawat Tibbil Qulub',
          'Sholawat Ilmi',
          'Sholawat Kamaliyah',
          'Sholawat Busyro',
          'Sholawat Badar',
        ],
      ),
      (
        'Maulid & Qashidah',
        const [
          'Maulid Barzanji Nadzom',
          'Maulid Diba\'i',
          'Qashidah Burdah',
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: NurKitabColors.deepGreen,
      appBar: nurKitabAppBar('Sholawat, Maulid & Qashidah'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: sections.expand((section) sync* {
          yield Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 4),
            child: Text(
              section.$1,
              style: const TextStyle(
                color: NurKitabColors.gold,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          );
          for (final item in section.$2) {
            yield Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: nurKitabCardDecoration(radius: 12),
              child: ListTile(
                title: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: NurKitabColors.gold,
                ),
                onTap: () {
                  if (item == 'Maulid Diba\'i') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubMenuMaulidDibai(
                          skalaFont: skalaFont,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    );
                    return;
                  }

                  String fName = 'sholawat';
                  if (item.startsWith('Maulid')) {
                    fName = 'maulid';
                  } else if (item.startsWith('Qashidah')) {
                    fName = 'qashidah';
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IsiBacaanPage(
                        judul: item,
                        fileName: fName,
                        skalaFont: skalaFont,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }).toList(),
      ),
    );
  }
}

class YasinTahlilPage extends StatelessWidget {
  final double skalaFont;
  final bool isDarkMode;

  const YasinTahlilPage({
    super.key,
    required this.skalaFont,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final items = ['Surah Yasin', 'Tahlil', 'Doa Tahlil'];

    return Scaffold(
      backgroundColor: NurKitabColors.deepGreen,
      appBar: nurKitabAppBar('Yasin & Tahlil'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final judul = items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: nurKitabCardDecoration(radius: 12),
            child: ListTile(
              leading: nurKitabAsset(
                NurKitabAssets.iconYasin,
                width: 40,
                height: 40,
              ),
              title: Text(
                judul,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: NurKitabColors.gold,
              ),
              onTap: () {
                if (judul == 'Surah Yasin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HalamanMubarakQuran(
                        nomorSurah: 36,
                        judulSurah: 'Yasin',
                        skalaFont: skalaFont,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IsiBacaanPage(
                        judul: judul,
                        fileName: 'tahlil',
                        skalaFont: skalaFont,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class SurahPendekPage extends StatefulWidget {
  final double skalaFont;
  final bool isDarkMode;

  const SurahPendekPage({
    super.key,
    required this.skalaFont,
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
      final String jsonString = await rootBundle.loadString(
        'asset/json/surah.json',
      );
      final Map<String, dynamic> dataJson = json.decode(jsonString);
      setState(() {
        _daftarSurah = dataJson['data'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: NurKitabColors.deepGreen,
        appBar: AppBar(
          backgroundColor: NurKitabColors.deepGreen,
          elevation: 0,
          title: const Text(
            'Al-Qur\'an',
            style: TextStyle(
              color: NurKitabColors.gold,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: NurKitabColors.gold),
          bottom: const TabBar(
            indicatorColor: NurKitabColors.gold,
            labelColor: NurKitabColors.gold,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Surah'),
              Tab(text: 'Juz'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: NurKitabColors.gold),
              )
            : TabBarView(
                children: [
                  // Tab Surah
                  ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _daftarSurah.length,
                    itemBuilder: (context, index) {
                      final surah = _daftarSurah[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: nurKitabCardDecoration(radius: 12),
                        child: ListTile(
                          leading: SizedBox(
                            width: 48,
                            height: 48,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                nurKitabAsset(
                                  NurKitabAssets.iconQuran,
                                  width: 44,
                                  height: 44,
                                ),
                                Text(
                                  "${surah['nomor'] ?? surah['id'] ?? ''}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    shadows: [
                                      Shadow(color: Colors.black, blurRadius: 4),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            surah['namaLatin'] ?? surah['surat_name'] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "${(surah['tempatTurun'] ?? surah['surat_terjemahan'] ?? '').toString().split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}' : '').join(' ')} • ${surah['jumlahAyat'] ?? surah['count_ayat'] ?? ''} Ayat",
                            style: const TextStyle(
                              color: NurKitabColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Text(
                            surah['nama'] ?? surah['surat_text'] ?? '',
                            style: const TextStyle(
                              color: NurKitabColors.gold,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HalamanMubarakQuran(
                                  nomorSurah: surah['nomor'] ?? surah['id'] ?? 1,
                                  judulSurah:
                                      surah['namaLatin'] ?? surah['surat_name'] ?? '',
                                  skalaFont: widget.skalaFont,
                                  isDarkMode: widget.isDarkMode,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  // Tab Juz
                  ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: juzMapping.length,
                    itemBuilder: (context, index) {
                      final juz = juzMapping[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: nurKitabCardDecoration(radius: 12),
                        child: ListTile(
                          leading: SizedBox(
                            width: 48,
                            height: 48,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                nurKitabAsset(
                                  NurKitabAssets.iconQuran,
                                  width: 44,
                                  height: 44,
                                ),
                                Text(
                                  "${juz['juz']}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    shadows: [
                                      Shadow(color: Colors.black, blurRadius: 4),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            "Juz ${juz['juz']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Surah ke-${juz['start_sura']} s.d Surah ke-${juz['end_sura']}",
                            style: const TextStyle(
                              color: NurKitabColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Text(
                            arabicJuzNames[index],
                            style: const TextStyle(
                              color: NurKitabColors.gold,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HalamanMubarakJuz(
                                  juzInfo: juz,
                                  skalaFont: widget.skalaFont,
                                  isDarkMode: widget.isDarkMode,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class SholawatPage extends StatelessWidget {
  final double skalaFont;
  final bool isDarkMode;

  const SholawatPage({
    super.key,
    required this.skalaFont,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> sholawat = [
      "Sholawat Tibbil Qulub",
      "Sholawat Ilmi",
      "Sholawat Kamaliyah",
      "Sholawat Busyro",
      "Sholawat Badar",
    ];
    return Scaffold(
      backgroundColor: NurKitabColors.deepGreen,
      appBar: nurKitabAppBar('Kumpulan Sholawat'),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: sholawat.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: nurKitabCardDecoration(radius: 12),
            child: ListTile(
              leading: nurKitabAsset(
                NurKitabAssets.iconSholawat,
                width: 40,
                height: 40,
              ),
              title: Text(
                sholawat[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: NurKitabColors.gold,
                size: 20,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IsiBacaanPage(
                      judul: sholawat[index],
                      fileName: 'sholawat',
                      skalaFont: skalaFont,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class MaulidPage extends StatelessWidget {
  final double skalaFont;
  final bool isDarkMode;

  const MaulidPage({
    super.key,
    required this.skalaFont,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> maulid = [
      "Maulid Barzanji Nadzom",
      "Maulid Diba\'i",
      "Qashidah Burdah (Bab 1)",
    ];
    return Scaffold(
      backgroundColor: NurKitabColors.deepGreen,
      appBar: nurKitabAppBar('Maulid & Qashidah'),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: maulid.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: nurKitabCardDecoration(radius: 12),
            child: ListTile(
              leading: nurKitabAsset(
                NurKitabAssets.iconSholawat,
                width: 40,
                height: 40,
              ),
              title: Text(
                maulid[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: NurKitabColors.gold,
                size: 20,
              ),
              onTap: () {
                if (maulid[index] == "Maulid Diba\'i") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubMenuMaulidDibai(
                        skalaFont: skalaFont,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  );
                  return;
                }

                String fName = maulid[index].startsWith('Maulid')
                    ? 'maulid'
                    : 'qashidah';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IsiBacaanPage(
                      judul: maulid[index],
                      fileName: fName,
                      skalaFont: skalaFont,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SubMenuMaulidDibai extends StatelessWidget {
  final double skalaFont;
  final bool isDarkMode;

  const SubMenuMaulidDibai({
    super.key,
    required this.skalaFont,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> dibaiChapters = [
      "Niat dan Hadiah Fatihah",
      "Ya Rabbi shalli...",
      "Ya Rasûlallah...",
      "Innâ fataḥnâ...",
      "Al-ḥamdulillâhil qawiyy...",
      "Qîla huwa âdam...",
      "Yub‘atsu min tihamah...",
      "Tsumma ardudduhu...",
      "Shalâtullâhi ma laḥat...",
      "Fasubḥânaman khashshahû...",
      "Awwalu mâ nastaftiḥu...",
      "Al-ḥadîtsul awwal...",
      "Al-ḥadîtsuts tsânî...",
      "Fayaqûlul haqqu...",
      "Ahdhirû qulûbakum...",
      "Fahtazzal arsyu...",
      "Mahallul Qiyâm: Yâ nabî salam...",
      "Wawulida shallallâhu...",
      "Qîla man yakfulu...",
      "Tsumma a’radla...",
      "Fabainamal habîbu...",
      "Faqâlatil malâikah...",
      "Fabainamal habîbu shallallâhu...",
      "Falammâ ra’athu halîmah...",
      "Wa kâna shallallâhu...",
      "Wa qîla liba’dlihim...",
      "Wa mâ ‘asâ an yuqâla...",
      "Ya badratimmin...",
      "Doa Maulid ad-Diba’i"
    ];

    return Scaffold(
      backgroundColor: NurKitabColors.deepGreen,
      appBar: nurKitabAppBar('Maulid Diba\'i'),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: dibaiChapters.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: nurKitabCardDecoration(radius: 12),
            child: ListTile(
              leading: nurKitabAsset(
                NurKitabAssets.iconSholawat,
                width: 40,
                height: 40,
              ),
              title: Text(
                "${index + 1}. ${dibaiChapters[index]}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: NurKitabColors.gold,
                size: 20,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MaulidDibaiSwipePage(
                      initialIndex: index,
                      dibaiChapters: dibaiChapters,
                      skalaFont: skalaFont,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class MaulidDibaiSwipePage extends StatefulWidget {
  final int initialIndex;
  final List<String> dibaiChapters;
  final double skalaFont;
  final bool isDarkMode;

  const MaulidDibaiSwipePage({
    super.key,
    required this.initialIndex,
    required this.dibaiChapters,
    required this.skalaFont,
    required this.isDarkMode,
  });

  @override
  State<MaulidDibaiSwipePage> createState() => _MaulidDibaiSwipePageState();
}

class _MaulidDibaiSwipePageState extends State<MaulidDibaiSwipePage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.dibaiChapters.length,
      itemBuilder: (context, index) {
        return IsiBacaanPage(
          judul: widget.dibaiChapters[index],
          fileName: 'maulid',
          skalaFont: widget.skalaFont,
          isDarkMode: widget.isDarkMode,
        );
      },
    );
  }
}

class HizibPage extends StatelessWidget {
  final double skalaFont;
  final bool isDarkMode;

  const HizibPage({
    super.key,
    required this.skalaFont,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> hizib = [
      "Ratib Al-Haddad",
      "Ratib Al-Atthas",
      "Hizib Nashor",
      "Hizib Bahar",
      "Munajat",
      "Jailani",
    ];
    return Scaffold(
      backgroundColor: NurKitabColors.deepGreen,
      appBar: nurKitabAppBar('Hizib & Ratib'),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: hizib.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: nurKitabCardDecoration(radius: 12),
            child: ListTile(
              leading: nurKitabAsset(
                NurKitabAssets.iconHizib,
                width: 40,
                height: 40,
              ),
              title: Text(
                hizib[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: NurKitabColors.gold,
                size: 20,
              ),
              onTap: () {
                String fName = hizib[index].startsWith('Ratib')
                    ? 'ratib'
                    : 'hizib';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IsiBacaanPage(
                      judul: hizib[index],
                      fileName: fName,
                      skalaFont: skalaFont,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class IsiBacaanPage extends StatefulWidget {
  final String judul;
  final String fileName;
  final double skalaFont;
  final bool isDarkMode;

  const IsiBacaanPage({
    super.key,
    required this.judul,
    required this.fileName,
    required this.skalaFont,
    required this.isDarkMode,
  });

  @override
  State<IsiBacaanPage> createState() => _IsiBacaanPageState();
}

class _IsiBacaanPageState extends State<IsiBacaanPage> {
  List<dynamic> _bacaanData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'asset/json/${widget.fileName}.json',
      );
      final Map<String, dynamic> dataJson = json.decode(jsonString);
      final List<dynamic> allData = dataJson['data'] ?? [];

      for (var item in allData) {
        if (item['judul'] == widget.judul) {
          setState(() {
            _bacaanData = item['bacaan'] ?? [];
            _isLoading = false;
          });
          return;
        }
      }

      // Jika tidak ditemukan
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode
          ? NurKitabColors.deepGreen
          : const Color(0xFFFDFBF7),
      appBar: nurKitabAppBar(widget.judul),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: NurKitabColors.gold),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              itemCount: _bacaanData.length,
              itemBuilder: (context, index) {
                final item = _bacaanData[index];

                if (item is Map) {
                  // Cek khusus untuk refrain Maulid Barzanji Nadzom
                  if (item['bait_kanan'] == "إِلهِيْ رَوِّحْ رُوْحَهُ وَ ضَرِيْحَهُ") {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: nurKitabCardDecoration(radius: 16).copyWith(
                        gradient: LinearGradient(
                          colors: widget.isDarkMode
                              ? [
                                  NurKitabColors.cardGreenLight,
                                  NurKitabColors.deepGreen,
                                ]
                              : [
                                  const Color(0xFFF2F6F3),
                                  const Color(0xFFE8EFEA),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: NurKitabColors.gold.withValues(alpha: 0.8),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            item['bait_kanan'] ?? '',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: widget.isDarkMode
                                  ? NurKitabColors.gold
                                  : NurKitabColors.deepGreen,
                              fontSize: 22 * widget.skalaFont,
                              fontWeight: FontWeight.bold,
                              height: 2.0,
                              fontFamily: 'Amiri',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['bait_kiri'] ?? '',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: widget.isDarkMode
                                  ? NurKitabColors.gold
                                  : NurKitabColors.deepGreen,
                              fontSize: 22 * widget.skalaFont,
                              fontWeight: FontWeight.bold,
                              height: 2.0,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Format Qashidah (Bait Kanan - Kiri)
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                item['bait_kiri'] ?? '',
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 20 * widget.skalaFont,
                                  height: 2.2,
                                  fontFamily: 'Amiri',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            "۞",
                            style: TextStyle(
                              color: widget.isDarkMode
                                  ? NurKitabColors.gold
                                  : NurKitabColors.deepGreen,
                              fontSize: 20 * widget.skalaFont,
                              height: 2.2,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                item['bait_kanan'] ?? '',
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 20 * widget.skalaFont,
                                  height: 2.2,
                                  fontFamily: 'Amiri',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Format biasa (List kalimat)
                  final bool isMasterTitle = index == 0 &&
                      (widget.judul.startsWith('Qashidah') ||
                          widget.judul.startsWith('Sholawat') ||
                          widget.judul.startsWith('Ratib') ||
                          widget.judul.startsWith('Hizib') ||
                          widget.judul == 'Munajat' ||
                          widget.judul == 'Maulid Barzanji Nadzom' ||
                          widget.judul == 'Jailani' ||
                          widget.judul == 'Tahlil' ||
                          widget.judul == 'Doa Tahlil');
                          
                  final String textItem = item.toString();
                  final bool isSubTitle = textItem == 'مَحَلُّ الْقِيَام' || textItem == 'دعاء مولد الديبعي';
                  final bool isSholawatPenutup = textItem.contains('اَللّٰهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَيْهِ');
                  
                  final bool isCenteredJailani = widget.judul == 'Jailani' && 
                      (textItem == '( الدُّعَاء )' || 
                       textItem == 'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ' || 
                       textItem == 'بِحُرْمَةِ الْفَاتِحَةِ');
                  final bool isBoldJailani = widget.judul == 'Jailani' && textItem == '( الدُّعَاء )';
                  
                  final bool isCenter = isMasterTitle || isSubTitle || isSholawatPenutup || isCenteredJailani ||
                      widget.judul == 'Qashidah Burdah' ||
                      widget.judul == 'Sholawat Badar' ||
                      (widget.judul == 'Maulid Barzanji Nadzom' &&
                          (textItem.contains('بِسْمِ اللهِ') ||
                              textItem.contains('سُبْحَانَ اللهِ')));

                  Widget contentWidget = Text(
                    textItem,
                    textDirection: TextDirection.rtl,
                    textAlign: isCenter ? TextAlign.center : TextAlign.justify,
                    style: TextStyle(
                      color: widget.isDarkMode
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: (isSholawatPenutup || isBoldJailani) ? FontWeight.bold : null,
                      fontSize: (isMasterTitle || isSubTitle)
                          ? 38 * widget.skalaFont
                          : 26 * widget.skalaFont,
                      height: (isMasterTitle || isSubTitle) ? 1.5 : 2.4,
                      fontFamily: (isMasterTitle || isSubTitle) ? 'ArefRuqaa' : 'Amiri',
                    ),
                  );

                  if (isMasterTitle) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30, top: 10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: widget.isDarkMode ? Colors.white38 : Colors.black38,
                              width: 1.5,
                            ),
                            bottom: BorderSide(
                              color: widget.isDarkMode ? Colors.white38 : Colors.black38,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: contentWidget,
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: contentWidget,
                  );
                }
              },
            ),
    );
  }
}

class HalamanMubarakQuran extends StatefulWidget {
  final int nomorSurah;
  final String judulSurah;
  final double skalaFont;
  final bool isDarkMode;

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
  String _surahArab = "";
  String _countAyat = "";

  @override
  void initState() {
    super.initState();
    _ambilDetailSurah();
    _simpanBacaanTerakhir();
  }

  Future<void> _simpanBacaanTerakhir() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_read_type', 'surah');
      await prefs.setInt('last_surah_nomor', widget.nomorSurah);
      await prefs.setString('last_surah_nama', widget.judulSurah);
    } catch (e) {
      // Menghindari crash jika storage bermasalah
    }
  }

  Future<void> _ambilDetailSurah() async {
    try {
      // Ambil metadata surah dari surah.json
      final String surahMetadataJson = await rootBundle.loadString('asset/json/surah.json');
      final Map<String, dynamic> allSurah = json.decode(surahMetadataJson);
      final List<dynamic> listSurah = allSurah['data'] ?? [];
      final surahInfo = listSurah.firstWhere(
          (s) => s['id'] == widget.nomorSurah,
          orElse: () => null);

      final String jsonString = await rootBundle.loadString(
        'asset/json/surah/${widget.nomorSurah}.json',
      );
      final Map<String, dynamic> dataJson = json.decode(jsonString);
      
      setState(() {
        _detailSurah = dataJson;
        if (surahInfo != null) {
          _surahArab = surahInfo['surat_text']?.toString().trim() ?? "";
          _countAyat = surahInfo['count_ayat']?.toString() ?? "";
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // 🟢 Fungsi pembantu untuk mengubah angka biasa (1,2,3) menjadi angka Arab (١,٢,٣)
  String _konversiKeAngkaArab(String nomor) {
    const angkaBiasa = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const angkaArab = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String hasil = nomor;
    for (int i = 0; i < angkaBiasa.length; i++) {
      hasil = hasil.replaceAll(angkaBiasa[i], angkaArab[i]);
    }
    return hasil;
  }

  String _ambilGabunganAyat() {
    if (_detailSurah == null) return "";

    List<dynamic> ayatList = [];
    if (_detailSurah!['ayat'] != null) {
      ayatList = _detailSurah!['ayat'];
    } else if (_detailSurah!['data'] != null && _detailSurah!['data'] is List) {
      ayatList = _detailSurah!['data'];
    }

    String totalTeks = "";
    for (var ayat in ayatList) {
      // 🟢 Ubah nomor ayat menjadi angka Arab sebelum digabungkan ke dalam teks
      String nomor =
          (ayat['nomorAyat'] ?? ayat['nomor'] ?? ayat['aya_number'] ?? '')
              .toString();
      String teks =
          (ayat['teksArab'] ??
                  ayat['text'] ??
                  ayat['ar'] ??
                  ayat['aya_text'] ??
                  '')
              .toString();
      String nomorArab = _konversiKeAngkaArab(nomor);
      totalTeks += "$teks ﴿$nomorArab﴾ ";
    }
    return totalTeks;
  }



  Widget _buildSurahHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.isDarkMode
                    ? [
                        NurKitabColors.cardGreenLight.withValues(alpha: 0.3),
                        NurKitabColors.deepGreen,
                      ]
                    : [
                        const Color(0xFFF2F6F3),
                        const Color(0xFFE8EFEA),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: NurKitabColors.gold.withValues(alpha: 0.8),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Kiri: Nama Surah Latin
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.judulSurah,
                    style: TextStyle(
                      fontSize: 14 * widget.skalaFont,
                      fontWeight: FontWeight.bold,
                      color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
                // Tengah: Nama Arab Surah
                Expanded(
                  flex: 2,
                  child: Text(
                    "سُوْرَةُ ${_surahArab.isNotEmpty ? _surahArab : widget.judulSurah}",
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 26 * widget.skalaFont,
                      fontFamily: 'ArefRuqaa',
                      fontWeight: FontWeight.bold,
                      color: widget.isDarkMode ? NurKitabColors.gold : Colors.black87,
                    ),
                  ),
                ),
                // Kanan: Jumlah Ayat
                Expanded(
                  flex: 1,
                  child: Text(
                    "${_countAyat.isNotEmpty ? _countAyat : '-'} Ayat",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14 * widget.skalaFont,
                      fontWeight: FontWeight.bold,
                      color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.nomorSurah != 9 && widget.nomorSurah != 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ",
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 28 * widget.skalaFont,
                fontFamily: 'ArefRuqaa',
                color: widget.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode
          ? NurKitabColors.deepGreen
          : const Color(0xFFFDFBF7),
      appBar: nurKitabAppBar(
        _detailSurah != null && _detailSurah!['namaLatin'] != null
            ? "${_detailSurah!['namaLatin']}"
            : widget.judulSurah,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: NurKitabColors.gold),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSurahHeader(),
                  Text(
                    _ambilGabunganAyat(),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 26 * widget.skalaFont,
                      height: 2.4,
                      color: widget.isDarkMode ? Colors.white : Colors.black87,
                      fontFamily: 'Amiri',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class HalamanMubarakJuz extends StatefulWidget {
  final Map<String, dynamic> juzInfo;
  final double skalaFont;
  final bool isDarkMode;

  const HalamanMubarakJuz({
    super.key,
    required this.juzInfo,
    required this.skalaFont,
    required this.isDarkMode,
  });

  @override
  State<HalamanMubarakJuz> createState() => _HalamanMubarakJuzState();
}

class _HalamanMubarakJuzState extends State<HalamanMubarakJuz> {
  bool _isLoading = true;
  List<Widget> _juzContent = [];

  @override
  void initState() {
    super.initState();
    _ambilDetailJuz();
    _simpanBacaanTerakhir();
  }

  Future<void> _simpanBacaanTerakhir() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_read_type', 'juz');
      await prefs.setInt('last_juz_nomor', widget.juzInfo['juz']);
      await prefs.remove('last_juz_surah');
    } catch (e) {
      // Menghindari crash jika storage bermasalah
    }
  }

  // 🟢 Fungsi pembantu untuk mengubah angka biasa (1,2,3) menjadi angka Arab (١,٢,٣)
  String _konversiKeAngkaArab(String nomor) {
    const angkaBiasa = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const angkaArab = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String hasil = nomor;
    for (int i = 0; i < angkaBiasa.length; i++) {
      hasil = hasil.replaceAll(angkaBiasa[i], angkaArab[i]);
    }
    return hasil;
  }

  Future<void> _ambilDetailJuz() async {
    try {
      int startSura = widget.juzInfo['start_sura'];
      int endSura = widget.juzInfo['end_sura'];
      int targetJuz = widget.juzInfo['juz'];

      // Ambil metadata surah dari surah.json
      final String surahMetadataJson = await rootBundle.loadString('asset/json/surah.json');
      final Map<String, dynamic> allSurah = json.decode(surahMetadataJson);
      final List<dynamic> listSurah = allSurah['data'] ?? [];

      List<Widget> contentWidgets = [];
      String currentTextBuffer = "";

      void flushTextBuffer() {
        if (currentTextBuffer.isNotEmpty) {
          contentWidgets.add(
            Text(
              currentTextBuffer,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 26 * widget.skalaFont,
                height: 2.4,
                color: widget.isDarkMode ? Colors.white : Colors.black87,
                fontFamily: 'Amiri',
              ),
            ),
          );
          currentTextBuffer = "";
        }
      }

      for (int i = startSura; i <= endSura; i++) {
        final String jsonString = await rootBundle.loadString(
          'asset/json/surah/$i.json',
        );
        final Map<String, dynamic> dataJson = json.decode(jsonString);
        
        List<dynamic> ayatList = [];
        if (dataJson['ayat'] != null) {
          ayatList = dataJson['ayat'];
        } else if (dataJson['data'] != null && dataJson['data'] is List) {
          ayatList = dataJson['data'];
        }

        for (var ayat in ayatList) {
          if (ayat['juz_id'] == targetJuz) {
            String nomor =
                (ayat['nomorAyat'] ?? ayat['nomor'] ?? ayat['aya_number'] ?? '')
                    .toString();
            String teks =
                (ayat['teksArab'] ??
                        ayat['text'] ??
                        ayat['ar'] ??
                        ayat['aya_text'] ??
                        '')
                    .toString();
            
            if (nomor == '1') {
              flushTextBuffer(); // Kosongkan buffer teks sebelumnya

              final surahInfo = listSurah.firstWhere(
                  (s) => s['id'] == i,
                  orElse: () => null);

              String surahName = surahInfo != null ? (surahInfo['surat_name'] ?? "Surah $i") : "Surah $i";
              String surahArab = surahInfo != null ? (surahInfo['surat_text']?.toString().trim() ?? "") : "";
              String countAyat = surahInfo != null ? (surahInfo['count_ayat']?.toString() ?? "") : "";

              contentWidgets.add(
                VisibilityDetector(
                  key: Key('juz_${targetJuz}_surah_$i'),
                  onVisibilityChanged: (visibilityInfo) async {
                    if (visibilityInfo.visibleFraction > 0.05) {
                      try {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('last_juz_surah', surahName);
                      } catch (e) {
                        // ignore
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24, top: 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.isDarkMode
                              ? [
                                  NurKitabColors.cardGreenLight.withValues(alpha: 0.3),
                                  NurKitabColors.deepGreen,
                                ]
                              : [
                                  const Color(0xFFF2F6F3),
                                  const Color(0xFFE8EFEA),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: NurKitabColors.gold.withValues(alpha: 0.8),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              surahName,
                              style: TextStyle(
                                fontSize: 14 * widget.skalaFont,
                                fontWeight: FontWeight.bold,
                                color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "سُوْرَةُ ${surahArab.isNotEmpty ? surahArab : surahName}",
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 26 * widget.skalaFont,
                                fontFamily: 'ArefRuqaa',
                                fontWeight: FontWeight.bold,
                                color: widget.isDarkMode ? NurKitabColors.gold : Colors.black87,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${countAyat.isNotEmpty ? countAyat : '-'} Ayat",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14 * widget.skalaFont,
                                fontWeight: FontWeight.bold,
                                color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );

              // Tambahkan Bismillah di tengah jika ini adalah awal surah (kecuali Al-Fatihah dan At-Taubah)
              if (i != 1 && i != 9) {
                contentWidgets.add(
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text(
                      "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 28 * widget.skalaFont,
                        fontFamily: 'ArefRuqaa',
                        color: widget.isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              }
            }
            
            String nomorArab = _konversiKeAngkaArab(nomor);
            currentTextBuffer += "$teks ﴿$nomorArab﴾ ";
          }
        }
      }
      
      flushTextBuffer(); // Kosongkan sisa buffer teks terakhir

      setState(() {
        _juzContent = contentWidgets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode
          ? NurKitabColors.deepGreen
          : const Color(0xFFFDFBF7),
      appBar: nurKitabAppBar("Juz ${widget.juzInfo['juz']}"),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: NurKitabColors.gold),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _juzContent,
              ),
            ),
    );
  }
}

class IslamicCalendarPage extends StatefulWidget {
  final String namaLokasi;

  const IslamicCalendarPage({super.key, required this.namaLokasi});

  @override
  State<IslamicCalendarPage> createState() => _IslamicCalendarPageState();
}

class _IslamicCalendarPageState extends State<IslamicCalendarPage> {
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;
  List<dynamic> _calendarDays = [];
  Map<String, String> _monthlyHolidays = {};
  bool _isLoading = true;
  String _errorMsg = "";

  final List<String> _namaBulanMasehi = [
    "",
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];

  @override
  void initState() {
    super.initState();
    _fetchCalendar();
  }

  String? _terjemahkanLiburIslam(String engName) {
    String lower = engName.toLowerCase();
    if (lower.contains("eid al-fitr")) return "Hari Raya Idul Fitri";
    if (lower.contains("eid al-adha")) return "Hari Raya Idul Adha";
    if (lower.contains("islamic new year")) return "Tahun Baru Islam";
    if (lower.contains("1st of ramadan")) return "Awal Ramadhan";
    if (lower.contains("ashura")) return "Hari Asyura";
    if (lower.contains("arafa")) return "Hari Arafah";
    if (lower.contains("isra") && lower.contains("mi'raj")) {
      return "Isra Mi'raj Nabi Muhammad SAW";
    }
    if (lower.contains("mawlid") || lower.contains("maulid")) {
      return "Maulid Nabi Muhammad SAW";
    }
    return null;
  }

  Future<void> _fetchCalendar() async {
    setState(() {
      _isLoading = true;
      _errorMsg = "";
      _monthlyHolidays.clear();
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      double lat = prefs.getDouble('jadwal_lat') ?? -7.1561;
      double lng = prefs.getDouble('jadwal_lng') ?? 113.4812;

      final url =
          'https://api.aladhan.com/v1/calendar/$_currentYear/$_currentMonth?latitude=$lat&longitude=$lng&method=20';
      final respon = await http.get(Uri.parse(url));

      if (respon.statusCode == 200) {
        final data = json.decode(respon.body)['data'];

        Map<String, String> holidays = {};
        try {
          final urlHolidays =
              'https://date.nager.at/api/v3/PublicHolidays/$_currentYear/ID';
          final responHolidays = await http.get(Uri.parse(urlHolidays));
          if (responHolidays.statusCode == 200) {
            final dataHolidays = json.decode(responHolidays.body) as List;
            for (var h in dataHolidays) {
              final dateStr = h['date'];
              if (dateStr.startsWith(
                "$_currentYear-${_currentMonth.toString().padLeft(2, '0')}",
              )) {
                holidays[dateStr] = h['localName'] ?? h['name'];
              }
            }
          }
        } catch (_) {}

        for (var day in data) {
          final gregorian = day['date']['gregorian'];
          final int tgl = int.parse(gregorian['day'].toString());
          final dateStr =
              "$_currentYear-${_currentMonth.toString().padLeft(2, '0')}-${tgl.toString().padLeft(2, '0')}";

          List<dynamic> hijriHolidays = day['date']['hijri']['holidays'] ?? [];
          if (hijriHolidays.isNotEmpty) {
            final translated = hijriHolidays
                .map((h) => _terjemahkanLiburIslam(h.toString()))
                .where((h) => h != null)
                .toList();
            if (translated.isNotEmpty) {
              final joined = translated.join(", ");
              if (holidays.containsKey(dateStr)) {
                holidays[dateStr] = "${holidays[dateStr]} & $joined";
              } else {
                holidays[dateStr] = joined;
              }
            }
          }
        }

        setState(() {
          _calendarDays = data;
          _monthlyHolidays = holidays;
          _isLoading = false;
        });
      } else {
        throw Exception("Gagal memuat kalender: ${respon.statusCode}");
      }
    } catch (e) {
      setState(() {
        _errorMsg =
            "Gagal mengambil data kalender bulanan.\nDetail: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  void _nextMonth() {
    if (_currentMonth == 12) {
      _currentMonth = 1;
      _currentYear++;
    } else {
      _currentMonth++;
    }
    _fetchCalendar();
  }

  void _prevMonth() {
    if (_currentMonth == 1) {
      _currentMonth = 12;
      _currentYear--;
    } else {
      _currentMonth--;
    }
    _fetchCalendar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NurKitabColors.deepGreen,
      appBar: AppBar(
        title: const Text(
          "Kalender",
          style: TextStyle(
            color: NurKitabColors.gold,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: NurKitabColors.deepGreen,
        foregroundColor: NurKitabColors.gold,
        iconTheme: const IconThemeData(color: NurKitabColors.gold),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: NurKitabColors.cardGreenLight,
              border: Border(
                bottom: BorderSide(
                  color: NurKitabColors.gold.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: NurKitabColors.gold,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.namaLokasi,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _prevMonth,
                      icon: const Icon(
                        Icons.chevron_left,
                        color: NurKitabColors.gold,
                      ),
                    ),
                    Text(
                      "${_namaBulanMasehi[_currentMonth]} $_currentYear",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: _nextMonth,
                      icon: const Icon(
                        Icons.chevron_right,
                        color: NurKitabColors.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: NurKitabColors.gold,
                    ),
                  )
                : _errorMsg.isNotEmpty
                ? Center(
                    child: Text(
                      _errorMsg,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:
                              ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"]
                                  .map(
                                    (day) => Expanded(
                                      child: Center(
                                        child: Text(
                                          day,
                                          style: const TextStyle(
                                            color: NurKitabColors.gold,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            int offset = 0;
                            if (_calendarDays.isNotEmpty) {
                              final firstDayStr =
                                  _calendarDays[0]['date']['gregorian']['weekday']['en'];
                              switch (firstDayStr) {
                                case 'Monday':
                                  offset = 0;
                                  break;
                                case 'Tuesday':
                                  offset = 1;
                                  break;
                                case 'Wednesday':
                                  offset = 2;
                                  break;
                                case 'Thursday':
                                  offset = 3;
                                  break;
                                case 'Friday':
                                  offset = 4;
                                  break;
                                case 'Saturday':
                                  offset = 5;
                                  break;
                                case 'Sunday':
                                  offset = 6;
                                  break;
                              }
                            }

                            return GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    childAspectRatio: 0.85,
                                    crossAxisSpacing: 6,
                                    mainAxisSpacing: 6,
                                  ),
                              itemCount: _calendarDays.length + offset,
                              itemBuilder: (context, index) {
                                if (index < offset) {
                                  return const SizedBox();
                                }

                                final dayIndex = index - offset;
                                final dayData = _calendarDays[dayIndex];
                                final gregorian = dayData['date']['gregorian'];
                                final hijri = dayData['date']['hijri'];

                                final tglMasehi = int.parse(gregorian['day']);
                                final blnMasehi = gregorian['month']['number'];
                                final thnMasehi = int.parse(gregorian['year']);

                                final isToday =
                                    (tglMasehi == DateTime.now().day &&
                                    blnMasehi == DateTime.now().month &&
                                    thnMasehi == DateTime.now().year);

                                final dateStr =
                                    "$thnMasehi-${blnMasehi.toString().padLeft(2, '0')}-${tglMasehi.toString().padLeft(2, '0')}";
                                final isHoliday = _monthlyHolidays.containsKey(
                                  dateStr,
                                );
                                final isFriday = (index % 7 == 4);
                                final isSunday = (index % 7 == 6);

                                Color masehiColor = Colors.white;
                                if (isHoliday || isSunday) {
                                  masehiColor = Colors.redAccent;
                                } else if (isFriday) {
                                  masehiColor = Colors.greenAccent;
                                }
                                if (isToday) masehiColor = NurKitabColors.gold;

                                DateTime d1 = DateTime.utc(1970, 1, 1);
                                DateTime d2 = DateTime.utc(thnMasehi, blnMasehi, tglMasehi);
                                int deltaDays = d2.difference(d1).inDays;
                                List<String> pasaranNames = ["Wage", "Kliwon", "Legi", "Pahing", "Pon"];
                                String pasaran = pasaranNames[deltaDays % 5];

                                return Container(
                                  decoration: BoxDecoration(
                                    color: isToday
                                        ? NurKitabColors.gold.withValues(
                                            alpha: 0.2,
                                          )
                                        : NurKitabColors.cardGreen.withValues(
                                            alpha: 0.6,
                                          ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isToday
                                          ? NurKitabColors.gold
                                          : NurKitabColors.gold.withValues(
                                              alpha: 0.1,
                                            ),
                                      width: isToday ? 1.5 : 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$tglMasehi",
                                        style: TextStyle(
                                          color: masehiColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        pasaran,
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 9,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        "${hijri['day']}",
                                        style: TextStyle(
                                          color: NurKitabColors.gold.withValues(
                                            alpha: 0.9,
                                          ),
                                          fontSize: 11,
                                        ),
                                      ),
                                      if (isHoliday)
                                        Container(
                                          margin: const EdgeInsets.only(top: 2),
                                          width: 4,
                                          height: 4,
                                          decoration: const BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      if (_monthlyHolidays.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: NurKitabColors.cardGreenLight,
                            border: Border(
                              top: BorderSide(
                                color: NurKitabColors.gold.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Hari Libur & Peringatan:",
                                style: TextStyle(
                                  color: NurKitabColors.gold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ..._monthlyHolidays.entries.map((e) {
                                final parts = e.key.split('-');
                                final day = int.parse(parts[2]);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 70,
                                        child: Text(
                                          "$day ${_namaBulanMasehi[_currentMonth]}",
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "- ${e.value}",
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key});

  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  int _counter = 0;
  final int _target = 33;
  int _cycle = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      if (_counter > 0 && _counter % _target == 0) {
        _cycle++;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _cycle = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NurKitabColors.deepGreen,
      appBar: nurKitabAppBar('Tasbih Digital'),
      body: Stack(
        children: [
          // Logo Kiri Atas
          Positioned(
            top: 0,
            left: -20,
            child: Opacity(
              opacity: 0.35,
              child: nurKitabAsset(
                NurKitabAssets.archFrame,
                width: 200,
                height: 200,
              ),
            ),
          ),
          // Logo Kanan Atas
          Positioned(
            top: 0,
            right: -20,
            child: Opacity(
              opacity: 0.35,
              child: nurKitabAsset(
                NurKitabAssets.archFrame,
                width: 200,
                height: 200,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: NurKitabColors.cardGreenLight,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: NurKitabColors.gold.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Total Dzikir',
                        style: TextStyle(
                          color: NurKitabColors.goldDim,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$_counter',
                        style: const TextStyle(
                          color: NurKitabColors.gold,
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Serif',
                        ),
                      ),
                      if (_cycle > 0) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Siklus ke-$_cycle ($_target)',
                          style: TextStyle(
                            color: NurKitabColors.gold.withValues(alpha: 0.8),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 70),
                GestureDetector(
                  onTap: _incrementCounter,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: NurKitabColors.cardGreen,
                      border: Border.all(color: NurKitabColors.gold, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: NurKitabColors.gold.withValues(alpha: 0.15),
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.fingerprint,
                        size: 70,
                        color: NurKitabColors.gold.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                TextButton.icon(
                  onPressed: _resetCounter,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: NurKitabColors.goldDim,
                  ),
                  label: const Text(
                    'Reset',
                    style: TextStyle(
                      color: NurKitabColors.goldDim,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
