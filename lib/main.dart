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
            'Nur_Kitab',
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
          _buildWideCard('Al-Qur\'an', false),
          _buildWideCard('Dzikir Siang-Malam', false),
          _buildWideCard('Wirid Hari Jumat', false),
          _buildWideCard('Kumpulan Bacaan Sholawat', true),
          
          Row(
            children: [
              Expanded(child: _buildSquareCard('Amalan Mulia', false)),
              const SizedBox(width: 8),
              Expanded(child: _buildSquareCard('Maulid & Qashidah', false)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildSquareCard('Tuntunan Ziarah', false)),
              const SizedBox(width: 8),
              Expanded(child: _buildSquareCard('Hizib & Ratib', true)),
            ],
          ),
        ],
      );
    }

    Widget _buildWideCard(String title, bool isNew) {
      return Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: _cardDecoration(),
        child: Stack(
          children: [
            if (isNew) _badgeNew(),
            Center(
              child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }

    Widget _buildSquareCard(String title, bool isNew) {
      return Container(
        height: 120,
        decoration: _cardDecoration(),
        child: Stack(
          children: [
            if (isNew) _badgeNew(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }

    BoxDecoration _cardDecoration() {
      return BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
        image: NetworkImage(''),
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