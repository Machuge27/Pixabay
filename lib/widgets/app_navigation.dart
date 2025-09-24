import 'package:flutter/material.dart';

class AppNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  const AppNavigation({super.key, required this.selectedIndex, required this.onDestinationSelected});

  static const destinations = [
    NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
    NavigationDestination(icon: Icon(Icons.photo_library), label: 'Gallery'),
    NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 700;
    if (isWide) {
      // Side navigation for web/tablet
      return NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        labelType: NavigationRailLabelType.all,
        destinations: destinations
            .map((d) => NavigationRailDestination(
                  icon: d.icon,
                  label: Text(d.label),
                ))
            .toList(),
      );
    } else {
      // Drawer content for mobile
      return Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurpleAccent],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'Pixabay Web',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...destinations.asMap().entries.map((entry) {
            final index = entry.key;
            final destination = entry.value;
            return ListTile(
              title: Row(
                children: [
                  destination.icon,
                  const SizedBox(width: 16),
                  Text(destination.label),
                ],
              ),
              selected: selectedIndex == index,
              onTap: () => onDestinationSelected(index),
            );
          }),
        ],
      );
    }
  }
}
