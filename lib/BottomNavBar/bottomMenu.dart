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
   @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: const Color.fromRGBO(0, 146, 143, 10),
      unselectedItemColor: Colors.grey,
      items: [
        for (var routeName in routeNames.keys)
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  InkWell(
                    onTap: () => onTap(routeNames.keys.toList().indexOf(routeName)),
                    child: Icon(
                      getIconForRoute(routeName, currentIndex == routeNames.keys.toList().indexOf(routeName)),
                      color: currentIndex == routeNames.keys.toList().indexOf(routeName)
                          ?  const Color.fromRGBO(0, 146, 143, 10)
                          : Colors.grey,
                    ),
                  ),
                  if (currentIndex == routeNames.keys.toList().indexOf(routeName)) // Display the name only when selected
                    Text(
                      routeName,
                      style:  const TextStyle(
                        color:  Color.fromRGBO(0, 146, 143, 10)
                      ),
                    ),
                ],
              ),
              label: '', // Clear the label
            ),
      ],
    );
  }

  IconData getIconForRoute(String routeName, bool isSelected) {
    switch (routeName) {
      case 'Summary':
        return isSelected ? Icons.dashboard : Icons.dashboard_rounded;
      case 'Monthly Report':
        return isSelected ? Icons.add_circle : Icons.add_circle;
      case 'Final Report':
        return isSelected ? Icons.assignment : Icons.assignment_outlined;
      default:
        return isSelected ? Icons.dashboard : Icons.dashboard_rounded;
    }
  }
}

