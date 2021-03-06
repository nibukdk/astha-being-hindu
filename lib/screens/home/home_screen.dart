import 'package:astha/widgets/card_button/card_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//
import 'package:astha/provider/permissions/provider/permissions_provider.dart';
import 'package:astha/settings/router/utils/router_utils.dart';
import 'package:astha/widgets/app_bar/custom_app_bar.dart';
import 'package:astha/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:astha/widgets/user_drawer/user_drawer.dart';
import 'package:astha/screens/home/widgets/daily_quotes.dart';
// import 'package:astha/screens/temples/provider/temple_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // late AppPermissionProvider appPermission;
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
          title: APP_PAGE.home.routePageTitle,
        ),
        primary: true,
        bottomNavigationBar: BottomNavBar(navItemIndex: 0),
        body: FutureBuilder(
            future: Provider.of<AppPermissionProvider>(context, listen: false)
                .getLocation(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print("waiting");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.connectionState == ConnectionState.active) {
                  return const Center(
                    child: Text("Loading..."),
                  );
                } else {
                  return SafeArea(
                    child: SingleChildScrollView(
                        child: Column(children: [
                      DailyQuotes(availableHeight, availableWidth),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: GridView.count(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: [
                            CardButton(
                              Icons.temple_hindu_sharp,
                              "Find Temples Near You",
                              availableWidth,
                              APP_PAGE.temples.routeName,
                            ),
                            CardButton(
                              Icons.event,
                              "Coming Events",
                              availableWidth,
                              APP_PAGE.events.routeName,
                            ),
                            CardButton(
                              Icons.location_pin,
                              "Find Venues",
                              availableWidth,
                              APP_PAGE.venues.routeName,
                            ),
                            CardButton(
                              Icons.music_note,
                              "Morning Prayers",
                              availableWidth,
                              APP_PAGE.music.routeName,
                            ),
                            CardButton(
                              Icons.attach_money_sharp,
                              "Donate",
                              availableWidth,
                              APP_PAGE.donate.routeName,
                            ),
                          ],
                        ),
                      )
                    ])),
                  );
                }
              }
            }));
  }
}
