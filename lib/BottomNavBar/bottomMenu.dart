import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Map<String, String> routeNames;

  BottomMenu({
    required this.currentIndex,
    required this.onTap,
    required this.routeNames,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: const Color.fromRGBO(148, 112, 18, 1),
      unselectedItemColor: Colors.grey,
      items: routeNames.keys.map((routeName) {
        final isSelected =
            routeNames.keys.toList().indexOf(routeName) == currentIndex;
        return BottomNavigationBarItem(
          icon: Column(
            children: [
              InkWell(
                onTap: () => onTap(routeNames.keys.toList().indexOf(routeName)),
                child: Icon(
                  getIconForRoute(routeName, isSelected),
                  color: isSelected
                      ? const Color.fromRGBO(148, 112, 18, 1)
                      : Colors.grey,
                ),
              ),
              if (isSelected) // Display the name only when selected
                Text(
                  routeName,
                  style: TextStyle(
                    color: isSelected
                        ? const Color.fromRGBO(148, 112, 18, 1)
                        : Colors.grey,
                  ),
                ),
            ],
          ),
          label: '', // Clear the label
        );
      }).toList(),
    );
  }

  IconData getIconForRoute(String routeName, bool isSelected) {
    switch (routeName) {
      case 'Summary':
        return isSelected ? Icons.dashboard : Icons.dashboard_rounded;
      case 'Monthly Report':
        return isSelected ? Icons.edit : Icons.edit_document;
      case 'Final Report':
        return isSelected ? Icons.assignment : Icons.assignment_outlined;
      case 'Details':
        return isSelected ? Icons.person : Icons.person_2_rounded;
      case 'Placements':
        return isSelected ? Icons.place : Icons.place_rounded;
      default:
        return isSelected ? Icons.dashboard : Icons.dashboard_rounded;
    }
  }
}

