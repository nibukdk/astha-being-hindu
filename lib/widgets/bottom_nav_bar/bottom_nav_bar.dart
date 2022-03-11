import 'package:astha/settings/router/utils/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatefulWidget {
  late final int navItemIndex;
  BottomNavBar({required this.navItemIndex, Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // bool isActive = false;
  // Icon? activeIcon;

  static final List<String> _widgetOptions = [
    APP_PAGE.home.routeName,
    APP_PAGE.temples.routeName,
    APP_PAGE.events.routeName,
    // APP_PAGE.search.routeName,
  ];

  void _onItemTapped(int index) {
    GoRouter.of(context).goNamed(_widgetOptions[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shop),
          label: 'Shop',
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.primary,
      currentIndex: widget.navItemIndex,
      selectedItemColor: Theme.of(context).colorScheme.onPrimary,
      onTap: _onItemTapped,
    );
  }
}
