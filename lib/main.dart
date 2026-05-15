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

  