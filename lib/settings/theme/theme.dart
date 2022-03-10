import 'package:flutter/material.dart';

final ThemeData asthaTheme = _findTempleTheme();

//Define Base theme for app
ThemeData _findTempleTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: const Color.fromARGB(255, 255, 209, 166),
      primaryContainer: const Color.fromARGB(255, 255, 225, 166),
      secondary: const Color.fromARGB(255, 40, 46, 121),
      error: Colors.red,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      background: const Color.fromARGB(255, 255, 225, 166),
      onBackground: Colors.black,
    ),
    textTheme: _findTempleTextTheme(base.textTheme),
    // Set Themes for Input
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.black),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.0,
          color: Colors.black,
          style: BorderStyle.solid,
        ),
      ),
    ),

    // Define styles for elevated button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 254, 121, 64),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      ),
    ),
    // Define styles for text button
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
      ),
    ),
  );
}

TextTheme _findTempleTextTheme(TextTheme base) {
  return base.copyWith(
    headline1: base.headline1!.copyWith(
        fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),
    headline2: base.headline2!.copyWith(
        fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
    headline3: base.headline3!.copyWith(
        fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black),
    bodyText1: base.bodyText1!.copyWith(
        fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black),
    bodyText2: base.bodyText2!.copyWith(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
  );
}
