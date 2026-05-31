import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
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
    title: Text(title, style: const TextStyle(color: NurKitabColors.gold, fontWeight: FontWeight.w600)),
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
    border: Border.all(color: NurKitabColors.gold.withValues(alpha: 0.45), width: 1),
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

  bool isDarkMode = true;
  bool tampilkanTerjemahan = true;
  double skalaFont = 1.0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeContent(
        skalaFont: skalaFont,
        tampilkanTerjemahan: tampilkanTerjemahan,
        isDarkMode: isDarkMode,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onMoonTap: () => setState(() => currentIndex = 2),
      ),
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
      key: _scaffoldKey,
      backgroundColor: NurKitabColors.deepGreen,
      drawer: _buildDrawer(),
      body: pages[currentIndex],
      bottomNavigationBar: _NurKitabBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
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
                  nurKitabAsset(NurKitabAssets.archFrame, width: 48, height: 56),
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
              leading: const Icon(Icons.home_rounded, color: NurKitabColors.gold),
              title: const Text('Beranda', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() => currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined, color: NurKitabColors.gold),
              title: const Text('Jadwal Sholat', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() => currentIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: NurKitabColors.gold),
              title: const Text('Pengaturan', style: TextStyle(color: Colors.white)),
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
        border: Border(top: BorderSide(color: NurKitabColors.gold.withValues(alpha: 0.15))),
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

class HomeContent extends StatelessWidget {
  final double skalaFont;
  final bool tampilkanTerjemahan;
  final bool isDarkMode;
  final VoidCallback onMenuTap;
  final VoidCallback onMoonTap;

  const HomeContent({
    super.key,
    required this.skalaFont,
    required this.tampilkanTerjemahan,
    required this.isDarkMode,
    required this.onMenuTap,
    required this.onMoonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003320), NurKitabColors.deepGreen, Color(0xFF001408)],
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
                      child: nurKitabAsset(NurKitabAssets.mosqueDome, height: 160, fit: BoxFit.contain),
                    ),
                  ),
                  Positioned(
                    top: 24,
                    left: 8,
                    child: Opacity(
                      opacity: 0.45,
                      child: nurKitabAsset(NurKitabAssets.lantern, width: 56, height: 90),
                    ),
                  ),
                  Positioned(
                    top: 24,
                    right: 8,
                    child: Opacity(
                      opacity: 0.45,
                      child: nurKitabAsset(NurKitabAssets.lantern, width: 56, height: 90),
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
                _buildContinueCard(context),
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
          onPressed: onMenuTap,
          icon: const Icon(Icons.menu_rounded, color: NurKitabColors.gold, size: 28),
        ),
        IconButton(
          onPressed: onMoonTap,
          padding: EdgeInsets.zero,
          icon: nurKitabAsset(NurKitabAssets.crescentMoon, width: 32, height: 32),
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
              nurKitabAsset(NurKitabAssets.archFrame, width: 88, height: 100, fit: BoxFit.contain),
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
            Icon(Icons.diamond, size: 8, color: NurKitabColors.gold.withValues(alpha: 0.7)),
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
            Icon(Icons.diamond, size: 8, color: NurKitabColors.gold.withValues(alpha: 0.7)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Divider(color: NurKitabColors.gold.withValues(alpha: 0.35), thickness: 0.5)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.auto_awesome, size: 12, color: NurKitabColors.gold.withValues(alpha: 0.5)),
            ),
            Expanded(child: Divider(color: NurKitabColors.gold.withValues(alpha: 0.35), thickness: 0.5)),
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
                  border: Border.all(color: NurKitabColors.gold.withValues(alpha: 0.6), width: 1.5),
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
                      'LANJUTKAN BACAAN TERAKHIR',
                      style: TextStyle(
                        color: NurKitabColors.gold.withValues(alpha: 0.85),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Al-Kahfi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Ayat 12',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: NurKitabColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Terakhir dibuka 2 jam yang lalu',
                          style: TextStyle(color: NurKitabColors.textMuted, fontSize: 10),
                        ),
                      ],
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HalamanMubarakQuran(
                          nomorSurah: 18,
                          judulSurah: 'Al-Kahfi',
                          skalaFont: skalaFont,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow_rounded, color: Colors.black, size: 20),
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
          child: Icon(Icons.bookmark, color: NurKitabColors.gold.withValues(alpha: 0.9), size: 22),
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
          skalaFont: skalaFont,
          tampilkanTerjemahan: tampilkanTerjemahan,
          isDarkMode: isDarkMode,
        ),
      ),
      _MenuItem(
        title: 'Sholawat, Maulid & Qashidah',
        description: 'Kumpulan sholawat pilihan, maulid, dan qashidah yang indah penuh makna.',
        imageAsset: NurKitabAssets.iconSholawat,
        page: SholawatMaulidPage(
          skalaFont: skalaFont,
          tampilkanTerjemahan: tampilkanTerjemahan,
          isDarkMode: isDarkMode,
        ),
      ),
      _MenuItem(
        title: 'Yasin & Tahlil',
        description: 'Bacaan Yasin dan tahlil untuk mendoakan dan mengingat ahli kubur.',
        imageAsset: NurKitabAssets.iconYasin,
        page: YasinTahlilPage(
          skalaFont: skalaFont,
          tampilkanTerjemahan: tampilkanTerjemahan,
          isDarkMode: isDarkMode,
        ),
      ),
      _MenuItem(
        title: 'Hizib & Ratib',
        description: 'Kumpulan hizib dan ratib harian untuk wirid dan penjagaan diri.',
        imageAsset: NurKitabAssets.iconHizib,
        page: HizibPage(
          skalaFont: skalaFont,
          tampilkanTerjemahan: tampilkanTerjemahan,
          isDarkMode: isDarkMode,
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
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => item.page)),
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
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GANTI dengan memanggil nurKitabAsset langsung:
                    SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.44, // Mengatur tinggi proporsional ikon
                    child: Center(
                    child: nurKitabAsset(
                    item.imageAsset,
                    fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: NurKitabColors.gold,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      item.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 9.5,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: NurKitabColors.gold.withValues(alpha: 0.5)),
                      ),
                      child: const Icon(Icons.chevron_right, color: NurKitabColors.gold, size: 16),
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
      ..shader = RadialGradient(
        colors: [
          NurKitabColors.gold.withValues(alpha: 0.12),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.45));
    canvas.drawCircle(center, size.width * 0.45, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [NurKitabColors.cardGreenLight, NurKitabColors.deepGreen],
              ),
              border: Border(bottom: BorderSide(color: NurKitabColors.gold.withValues(alpha: 0.3))),
            ),
            child: Column(
              children: [
                const Text('Jakarta, Indonesia', style: TextStyle(fontSize: 16, color: Colors.white)),
                const SizedBox(height: 12),
                Text(
                  waktuSholatBerikutnya,
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: NurKitabColors.gold),
                ),
                const SizedBox(height: 6),
                Text(
                  "Menuju $namaSholatBerikutnya",
                  style: TextStyle(fontSize: 15, color: Colors.white.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: prayers.entries.map((e) {
                final isNext = e.key.toLowerCase() == namaSholatBerikutnya.toLowerCase();
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: nurKitabCardDecoration(radius: 12).copyWith(
                    border: Border.all(
                      color: isNext ? NurKitabColors.gold.withValues(alpha: 0.6) : NurKitabColors.gold.withValues(alpha: 0.2),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      e.key,
                      style: TextStyle(
                        color: isNext ? NurKitabColors.gold : Colors.white,
                        fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
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
                      isNext ? Icons.notifications_active : Icons.notifications_none,
                      color: isNext ? NurKitabColors.gold : NurKitabColors.goldDim,
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: NurKitabColors.gold),
            ),
          ),
          const SizedBox(height: 10),
          _settingsCard(
            SwitchListTile(
              secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: NurKitabColors.gold),
              title: const Text('Mode Gelap', style: TextStyle(color: Colors.white, fontSize: 16)),
              subtitle: Text(
                isDarkMode ? 'Tema gelap islami premium' : 'Tema terang',
                style: const TextStyle(color: NurKitabColors.textMuted, fontSize: 12),
              ),
              value: isDarkMode,
              activeThumbColor: NurKitabColors.gold,
              onChanged: onThemeChanged,
            ),
          ),
          _settingsCard(
            SwitchListTile(
              secondary: const Icon(Icons.translate, color: NurKitabColors.gold),
              title: const Text('Tampilkan Terjemahan', style: TextStyle(color: Colors.white, fontSize: 16)),
              subtitle: Text(
                tampilkanTerjemahan ? 'Terjemahan teks ditampilkan' : 'Hanya menampilkan teks Arab',
                style: const TextStyle(color: NurKitabColors.textMuted, fontSize: 12),
              ),
              value: tampilkanTerjemahan,
              activeThumbColor: NurKitabColors.gold,
              onChanged: onTranslationChanged,
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
                            Text('Ukuran Font Bacaan', style: TextStyle(color: Colors.white, fontSize: 16)),
                            Text(
                              'Atur skala besar kecil khusus teks ayat/bacaan',
                              style: TextStyle(color: NurKitabColors.textMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('A', style: TextStyle(color: Colors.white, fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: skalaFont,
                          min: 0.8,
                          max: 1.6,
                          divisions: 4,
                          activeColor: NurKitabColors.gold,
                          inactiveColor: NurKitabColors.goldDim.withValues(alpha: 0.4),
                          label: '${(skalaFont * 100).toInt()}%',
                          onChanged: onFontSizeChanged,
                        ),
                      ),
                      const Text('A', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _settingsCard(
            const ListTile(
              leading: Icon(Icons.info_outline, color: NurKitabColors.gold),
              title: Text('Tentang Aplikasi', style: TextStyle(color: Colors.white, fontSize: 16)),
              subtitle: Text('Versi 1.0.0', style: TextStyle(color: NurKitabColors.textMuted, fontSize: 12)),
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
  final bool tampilkanTerjemahan;
  final bool isDarkMode;

  const SholawatMaulidPage({
    super.key,
    required this.skalaFont,
    required this.tampilkanTerjemahan,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      ('Sholawat', const [
        'Sholawat Ibrahimiyah',
        'Sholawat Jibril',
        'Sholawat Nariyah',
        'Sholawat Munjiyat',
      ]),
      ('Maulid & Qashidah', const [
        'Maulid Simtutdurar (pembuka)',
        'Qashidah Burdah (Bab 1)',
        'Qashidah Ya Imamarusli',
        'Qashidah Busro Lana',
      ]),
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
              style: const TextStyle(color: NurKitabColors.gold, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          );
          for (final item in section.$2) {
            yield Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: nurKitabCardDecoration(radius: 12),
              child: ListTile(
                title: Text(item, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                trailing: const Icon(Icons.chevron_right, color: NurKitabColors.gold),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IsiBacaanPage(
                      judul: item,
                      skalaFont: skalaFont,
                      tampilkanTerjemahan: tampilkanTerjemahan,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ),
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
  final bool tampilkanTerjemahan;
  final bool isDarkMode;

  const YasinTahlilPage({
    super.key,
    required this.skalaFont,
    required this.tampilkanTerjemahan,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      'Surah Yasin',
      'Tahlil Ringkas',
      'Tahlil Lengkap',
      'Doa Tahlil Arwah',
    ];

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
              leading: nurKitabAsset(NurKitabAssets.iconYasin, width: 40, height: 40),
              title: Text(judul, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.chevron_right, color: NurKitabColors.gold),
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
                        skalaFont: skalaFont,
                        tampilkanTerjemahan: tampilkanTerjemahan,
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
      backgroundColor: NurKitabColors.deepGreen,
      appBar: nurKitabAppBar('Al-Qur\'an'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: NurKitabColors.gold))
          : ListView.builder(
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
                          nurKitabAsset(NurKitabAssets.iconQuran, width: 44, height: 44),
                          Text(
                            "${surah['nomor']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: Text(surah['namaLatin'], style: const TextStyle(color: Colors.white)),
                    subtitle: Text(
                      "${surah['tempatTurun'].toString().toUpperCase()} • ${surah['jumlahAyat']} Ayat",
                      style: const TextStyle(color: NurKitabColors.textMuted, fontSize: 12),
                    ),
                    trailing: Text(
                      surah['nama'],
                      style: const TextStyle(color: NurKitabColors.gold, fontSize: 16, fontWeight: FontWeight.bold),
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
                  ),
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
              leading: nurKitabAsset(NurKitabAssets.iconSholawat, width: 40, height: 40),
              title: Text(sholawat[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.chevron_right, color: NurKitabColors.gold, size: 20),
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
            ),
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
              leading: nurKitabAsset(NurKitabAssets.iconSholawat, width: 40, height: 40),
              title: Text(maulid[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.chevron_right, color: NurKitabColors.gold, size: 20),
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
            ),
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
              leading: nurKitabAsset(NurKitabAssets.iconHizib, width: 40, height: 40),
              title: Text(hizib[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.chevron_right, color: NurKitabColors.gold, size: 20),
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
            ),
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
      backgroundColor: NurKitabColors.deepGreen,
      appBar: nurKitabAppBar(judul),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: nurKitabCardDecoration(radius: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teksArab,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26 * skalaFont,
                  height: 2.2,
                  fontFamily: 'Amiri',
                ),
                textAlign: TextAlign.right,
              ),
              if (tampilkanTerjemahan) ...[
                Divider(color: NurKitabColors.gold.withValues(alpha: 0.4), height: 30),
                Text(
                  artiTeks,
                  style: TextStyle(
                    color: NurKitabColors.textMuted,
                    fontSize: 15 * skalaFont,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ],
          ),
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
      backgroundColor: NurKitabColors.deepGreen,
      appBar: nurKitabAppBar(_detailSurah != null ? "${_detailSurah!['namaLatin']}" : widget.judulSurah),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: NurKitabColors.gold))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Text(
                _ambilGabunganAyat(),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 26 * widget.skalaFont,
                  height: 2.4,
                  color: Colors.white,
                  fontFamily: 'Amiri',
                ),
              ),
            ),
    );
  }
}