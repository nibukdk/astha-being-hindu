import 'package:astha/screens/shop/widgets/personal_feed_widget.dart';
import 'package:astha/settings/router/utils/router_utils.dart';
import 'package:astha/widgets/app_bar/custom_app_bar.dart';
import 'package:astha/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:astha/widgets/pill_button/pill_button.dart';
import 'package:astha/widgets/user_drawer/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // This is device height
    final deviceHeight = MediaQuery.of(context).size.height;
    // Device width
    final deviceWidth = MediaQuery.of(context).size.width;
    // Subtract paddings to calculate available dimensions
    final availableHeight = deviceHeight -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    final availableWidth = deviceWidth -
        MediaQuery.of(context).padding.right -
        MediaQuery.of(context).padding.left;

    return Scaffold(
        key: _scaffoldKey,
        drawer: const UserDrawer(),
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
          title: APP_PAGE.shop.routePageTitle,
        ),
        primary: true,
        bottomNavigationBar: BottomNavBar(navItemIndex: 2),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PillButton(
                        icon: Icons.local_fire_department,
                        title: "Popular",
                        width: availableWidth,
                        routeName: APP_PAGE.shop.routeName,
                      ),
                      PillButton(
                        icon: Icons.shopping_cart,
                        title: "Cart",
                        width: availableWidth,
                        routeName: APP_PAGE.shop.routeName,
                      ),
                      PillButton(
                        icon: Icons.tune,
                        title: "Filter",
                        width: availableWidth,
                        routeName: APP_PAGE.shop.routeName,
                      ),
                    ],
                  )),
              const PersonalFeedWidget()
            ],
          )),
        ));
  }
}
