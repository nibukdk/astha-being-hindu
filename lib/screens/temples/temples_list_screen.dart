import 'package:astha/provider/permissions/provider/permissions_provider.dart';
import 'package:astha/screens/temples/provider/temple_provider.dart';
import 'package:astha/screens/temples/widgets/temple_item_widget.dart';
import 'package:astha/settings/router/utils/router_utils.dart';
import 'package:astha/widgets/app_bar/custom_app_bar.dart';
import 'package:astha/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:astha/widgets/user_drawer/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class TempleListScreen extends StatefulWidget {
  const TempleListScreen({Key? key}) : super(key: key);

  @override
  State<TempleListScreen> createState() => _TempleListScreenState();
}

class _TempleListScreenState extends State<TempleListScreen> {
  // late AppPermissionProvider appPermissionProvider;
  late TextEditingController _searchFormController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late FocusNode _searchFormFocusNode;
  LatLng? userLocation;
  Future? _temples;

  LatLng getLocation() {
    return userLocation =
        Provider.of<AppPermissionProvider>(context, listen: false)
            .locationCenter;
  }

  Future _nearbyTemples() {
    final location = getLocation();

    return Provider.of<TempleProvider>(context, listen: false)
        .getNearyByTemples(location);
  }

  @override
  void initState() {
    super.initState();
    _searchFormController = TextEditingController();
    _searchFormFocusNode = FocusNode();
    // appPermissionProvider = AppPermissionProvider();
    _temples = _nearbyTemples();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();

    _searchFormController.dispose();
    _searchFormFocusNode.dispose();
  }

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
        title: APP_PAGE.temples.routePageTitle,
        isSubPage: true,
      ),
      primary: true,
      bottomNavigationBar: BottomNavBar(navItemIndex: 0),
      body: SafeArea(
        child: FutureBuilder(
          future: _temples,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final templeList =
                  Provider.of<TempleProvider>(context, listen: false).temples;
              return SizedBox(
                width: availableWidth * 9,
                child: Column(
                  children: [
                    templeList.isEmpty
                        ? const Text("There are no temples around you")
                        : Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, i) => TempleItemWidget(
                                address: templeList[i].address,
                                imageUrl: templeList[i].imageUrl,
                                title: templeList[i].name,
                                width: availableWidth,
                                height: availableHeight,
                              ),
                              itemCount: templeList.length,
                            ),
                          )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
