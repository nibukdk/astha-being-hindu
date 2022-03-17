import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as location_package;

class AppPermissionProvider with ChangeNotifier {
  PermissionStatus _locationStatus = PermissionStatus.denied;
  FirebaseFunctions functions = FirebaseFunctions.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  LatLng? _locationCenter;
  LatLng? _changedLocation;

  bool _hasLocationChanged = false;

  final location_package.Location _location = location_package.Location();

  location_package.LocationData? _locationData;

  // Getter
  get locationStatus => _locationStatus;
  get locationCenter => _locationCenter;
  get location => _location;
  get hasLocationChanged => _hasLocationChanged;
  get changedLocation => _changedLocation;

  void getLocationStatus() async {
    final status = await Permission.location.request();
    _locationStatus = status;

    notifyListeners();
    // print(_locationStatus);
  }

  void getLocation() async {
    try {
      HttpsCallable addUserLocation =
          functions.httpsCallable('addUserLocation');
      _locationData = await _location.getLocation();
      _locationCenter = LatLng(_locationData!.latitude as double,
          _locationData!.longitude as double);

      await addUserLocation.call(
        <String, dynamic>{
          'userLocation': {
            'lat': _locationCenter != null
                ? _locationCenter!.latitude
                : "Not available",
            'lon': _locationCenter != null
                ? _locationCenter!.longitude
                : "Not available",
          }
        },
      );
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  // void getChangedLocation() {
  //   _location.onLocationChanged.listen((loc) {
  //     _hasLocationChanged = true;
  //     _changedLocation =
  //         LatLng(loc.latitude as double, loc.longitude as double);
  //   });
  //
  //   notifyListeners();
  // }
}
