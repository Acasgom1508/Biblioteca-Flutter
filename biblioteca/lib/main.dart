import 'package:flutter/material.dart';
import './screens/home.dart';
import './screens/profile.dart';
import './screens/carnet.dart';
import './screens/search.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(onNavigate: (index) => _onItemTapped(index)),
      const ProfileScreen(),
      const CarnetScreen(),
      const SearchScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 35), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 35), label: 'Perfil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_mail, size: 35), label: 'Carnet'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 35), label: 'Catálogo'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 140, 223, 143),
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color.fromARGB(255, 51, 96, 164),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
