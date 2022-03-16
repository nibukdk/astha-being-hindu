import 'package:astha/settings/router/utils/router_utils.dart';
import 'package:astha/widgets/app_bar/custom_app_bar.dart';
import 'package:astha/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:astha/widgets/user_drawer/user_drawer.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const UserDrawer(),
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
        title: APP_PAGE.favorite.routePageTitle,
      ),
      primary: true,
      bottomNavigationBar: BottomNavBar(navItemIndex: 1),
    );
  }
}
