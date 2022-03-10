import 'package:astha/provider/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen>
    with SingleTickerProviderStateMixin {
  int _currentImg = 0;

  final onBoardScreenImages = [
    "assets/onboard/FindTemples.png",
    "assets/onboard/FindVenues.png"
  ];

  void nextImage() {
    if (_currentImg < onBoardScreenImages.length - 1) {
      setState(() => _currentImg += 1);
    }
  }

  void prevImage() {
    if (_currentImg > 0) {
      setState(() => _currentImg -= 1);
    }
  }

  void onSubmitDone(AppStateProvider stateProvider, BuildContext context) {
    stateProvider.hasOnBoarded();
    GoRouter.of(context).go("/");
  }

  @override
  Widget build(BuildContext context) {
    final appStateProvider = Provider.of<AppStateProvider>(context);
    return Scaffold(
      body: SafeArea(
          child: Container(
              color: const Color.fromARGB(255, 255, 209, 166),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  AnimatedSwitcher(
                    // transitionBuilder: ((child, animation) =>
                    //     ScaleTransition(scale: animation, child: child)),
                    duration: const Duration(milliseconds: 800),
                    child: Image.asset(
                      onBoardScreenImages[_currentImg],
                      // fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: double.infinity,
                      key: ValueKey<int>(_currentImg),
                    ),
                  ),
                  Container(
                    color: Colors.black26,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: prevImage,
                          icon: _currentImg == 0
                              ? const Icon(null)
                              : const Icon(Icons.arrow_back),
                        ),
                        IconButton(
                          onPressed: _currentImg ==
                                  onBoardScreenImages.length - 1
                              ? () => onSubmitDone(appStateProvider, context)
                              : nextImage,
                          icon: _currentImg == onBoardScreenImages.length - 1
                              ? const Icon(Icons.done)
                              : const Icon(Icons.arrow_forward),
                        )
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}
