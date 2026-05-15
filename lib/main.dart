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
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Al-Qur\'an'), backgroundColor: Colors.black, foregroundColor: Colors.white),
        body: const Center(child: Text('Halaman Al-Qur\'an', style: TextStyle(color:Colors.white))),
      );
    }
  }
  class DzikirPage extends StatelessWidget {
    const DzikirPage({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Dzikir Siang-Malam'), backgroundColor: Colors.black,
        foregroundColor: Colors.white),
        body: const Center(child: Text('Halaman Dzikir', style: TextStyle(color: Colors.white))),
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
  