import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//
import 'app.dart';

int? onBoardCount;
const bool useEmulator = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  onBoardCount = prefs.getInt('onBoardKey');

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.black38),
  );

  // Firebase initalize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Firebase products instances
  FirebaseAuth authInstance = FirebaseAuth.instance;

// Set app to run on firebase emulator
  if (useEmulator) {
    await _connectToEmulator();
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
// Initialize dot env
  await dotenv.load(fileName: ".env");
  runApp(MyApp(prefs, onBoardCount, authInstance));
}

// Settings for firebase emulator connection
Future _connectToEmulator() async {
  final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  const authPort = 9099;
  const firestorePort = 8080;
  const functionsPort = 5001;
  const storagePort = 9199;

  print("I am running on emulator");

  await FirebaseAuth.instance.useAuthEmulator(host, authPort);
  FirebaseFirestore.instance.useFirestoreEmulator(host, firestorePort);
  FirebaseFunctions.instance.useFunctionsEmulator(host, functionsPort);
  FirebaseStorage.instance.useStorageEmulator(host, storagePort);
}
