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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library, size: 32, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Pixabay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...destinations.asMap().entries.map((entry) {
            final index = entry.key;
            final destination = entry.value;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color:
                    selectedIndex == index
                        ? Theme.of(context).primaryColor.withOpacity(0.15)
                        : Colors.transparent,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onDestinationSelected(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        (destination.icon as Icon).icon,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        destination.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              selectedIndex == index
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white70, size: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
