import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pages (to be implemented)
import 'pages/dashboard_page.dart';
import 'pages/gallery_page.dart';
import 'pages/profile_page.dart';
import 'widgets/app_navigation.dart';

void main() {
  runApp(const ProviderScope(child: PixabayApp()));
}

class PixabayApp extends StatelessWidget {
  const PixabayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixabay Web',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const DashboardPage(),
    const GalleryPage(),
    const ProfilePage(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Close drawer on mobile after selection
    if (MediaQuery.of(context).size.width < 700) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 700;
    
    return Scaffold(
      body: isWide
          ? Row(
              children: [
                AppNavigation(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onNavTap,
                ),
                Expanded(child: _pages[_selectedIndex]),
              ],
            )
          : _pages[_selectedIndex],
      drawer: !isWide
          ? Drawer(
              child: AppNavigation(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onNavTap,
              ),
            )
          : null,
    );
  }
}
