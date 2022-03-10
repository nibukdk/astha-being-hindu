import 'package:astha/screens/auth/widgets/auth_form_widget.dart';
import 'package:astha/settings/router/utils/router_utils.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_PAGE.auth.routePageTitle)),
      // drawer: const CustomDrawer(),
      // bottomNavigationBar: const BottomNavBar(),
      body: SafeArea(
        child: Listener(
          onPointerDown: (PointerDownEvent event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: SizedBox(
              // height: MediaQuery.of(context).size.height * 0.9,
              width: double.infinity,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/AuthScreen/WelcomeScreenImage_landscape_2.png',
                    fit: BoxFit.fill,
                  ),
                ),
                const AuthFormWidget()
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
