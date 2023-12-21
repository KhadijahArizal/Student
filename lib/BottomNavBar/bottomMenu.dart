import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Map<String, String> routeNames;
  final String studentStatus;

  BottomMenu({
    required this.currentIndex,
    required this.onTap,
    required this.routeNames,
    required this.studentStatus,
  });

  @override
   @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.teal.shade900,
      unselectedItemColor: Colors.grey,
      items: [
        for (var routeName in routeNames.keys)
          if (!((routeName == 'Monthly Report' || routeName == 'Final Report') &&
              studentStatus == 'Inactive'))
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  InkWell(
                    onTap: () => onTap(routeNames.keys.toList().indexOf(routeName)),
                    child: Icon(
                      getIconForRoute(routeName, currentIndex == routeNames.keys.toList().indexOf(routeName)),
                      color: currentIndex == routeNames.keys.toList().indexOf(routeName)
                          ?  Colors.teal.shade900
                          : Colors.grey,
                    ),
                  ),
                  if (currentIndex == routeNames.keys.toList().indexOf(routeName)) // Display the name only when selected
                    Text(
                      routeName,
                      style:  TextStyle(
                        color:  Colors.teal.shade900,
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

