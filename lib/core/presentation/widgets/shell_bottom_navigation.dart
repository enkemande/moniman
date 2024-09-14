import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellBottomNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final List<BottomNavigationBarItem> items;

  const ShellBottomNavigation(
      {Key? key, required this.navigationShell, required this.items})
      : super(key: key ?? const ValueKey<String>('ShellBottomNavigation'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        items: items,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
