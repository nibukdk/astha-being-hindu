import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
//
import 'package:astha/screens/auth/provider/auth_state_provider.dart';
import 'package:astha/settings/router/utils/router_utils.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 209, 166),
      actionsPadding: EdgeInsets.zero,
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        "Astha",
        style: Theme.of(context).textTheme.headline1,
      ),
      content: const Divider(
        thickness: 1.0,
        color: Colors.black,
      ),
      actions: [
        ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('Logout'),
            onTap: () {
              Provider.of<AuthStateProvider>(context, listen: false).logOut();
              GoRouter.of(context).goNamed(APP_PAGE.auth.routeName);
            })
      ],
    );
  }
}
