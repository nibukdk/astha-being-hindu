// import 'package:astha/provider/permissions/provider/permissions_provider.dart';
// import 'package:astha/screens/auth/utils/auth_utils.dart';
// import 'package:astha/screens/temples/provider/temple_provider.dart';
// import 'package:astha/screens/temples/widgets/temple_item_widget.dart';
// import 'package:astha/settings/router/utils/router_utils.dart';
// import 'package:astha/widgets/app_bar/custom_app_bar.dart';
// import 'package:astha/widgets/bottom_nav_bar/bottom_nav_bar.dart';
// import 'package:astha/widgets/user_drawer/user_drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';

// class TempleListScreen extends StatefulWidget {
//   const TempleListScreen({Key? key}) : super(key: key);

//   @override
//   State<TempleListScreen> createState() => _TempleListScreenState();
// }

// class _TempleListScreenState extends State<TempleListScreen> {
//   late TextEditingController _searchFormController;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   late FocusNode _searchFormFocusNode;

//   @override
//   void initState() {
//     super.initState();
//     _searchFormController = TextEditingController();
//     _searchFormFocusNode = FocusNode();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     _searchFormController.dispose();
//     _searchFormFocusNode.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     LatLng userLocation =
//         Provider.of<AppPermissionProvider>(context, listen: false)
//             .locationCenter;
//     TempleProvider templeProvider =
//         Provider.of<TempleProvider>(context, listen: false);

//     templeProvider.getNearyByTemples(userLocation);
//     final ViewState viewState = templeProvider.viewState;

//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: const UserDrawer(),
//       appBar: CustomAppBar(
//         scaffoldKey: _scaffoldKey,
//         title: APP_PAGE.temples.routePageTitle,
//       ),
//       primary: true,
//       bottomNavigationBar: BottomNavBar(navItemIndex: 0),
//       body: SafeArea(
//         child: viewState == ViewState.busy
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//                 child: SizedBox(
//                   width: 400,
//                   height: 400,
//                   child: Column(
//                     children: [
//                       ...templeProvider.temples
//                           .map(
//                             (temple) => Expanded(
//                               child: TempleItemWidget(
//                                 address: temple.address,
//                                 imageUrl:
//                                     "https://maps.google.com/maps/contrib/103847398450218246302",
//                                 title: temple.name,
//                               ),
//                             ),
//                           )
//                           .toList()
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
