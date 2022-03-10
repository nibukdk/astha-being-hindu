import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as location_package;

class AppPermissionProvider with ChangeNotifier {
  PermissionStatus _locationStatus = PermissionStatus.denied;
  FirebaseAuth authInstance = FirebaseAuth.instance;
  LatLng? _locationCenter;

  final location_package.Location _location = location_package.Location();

  location_package.LocationData? _locationData;

  // Getter
  get locationStatus => _locationStatus;
  get locationCenter => _locationCenter;
  get location => _location;

  void getLocationStatus() async {
    final status = await Permission.location.request();
    _locationStatus = status;

    notifyListeners();
    print(_locationStatus);
  }

  void getLocation() async {
    CollectionReference user = FirebaseFirestore.instance.collection("users");

    _locationData = await _location.getLocation();
    _locationCenter = LatLng(
        _locationData!.latitude as double, _locationData!.longitude as double);

    print(_locationCenter);
    notifyListeners();
  }
}
