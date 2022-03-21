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
  get locationCenter => _locationCenter as LatLng;
  get location => _location;
  get hasLocationChanged => _hasLocationChanged;
  get changedLocation => _changedLocation;

  Future<PermissionStatus> getLocationStatus() async {
    final status = await Permission.location.request();
    _locationStatus = status;
    notifyListeners();
    return status;
    // print(_locationStatus);
  }

  Future<void> getLocation() async {
    final status = await getLocationStatus();
    if (status == PermissionStatus.granted ||
        status == PermissionStatus.limited) {
      try {
        HttpsCallable addUserLocation =
            functions.httpsCallable('addUserLocation');
        _locationData = await _location.getLocation();
        final lat = _locationData != null
            ? _locationData!.latitude as double
            : "Not available";
        final lon = _locationData != null
            ? _locationData!.longitude as double
            : "Not available";

        final response = await addUserLocation.call(
          <String, dynamic>{
            'userLocation': {
              'lat': lat,
              'lon': lon,
            }
          },
        );
        _locationCenter = LatLng(response.data['lat'], response.data['lon']);
      } catch (e) {
        _locationCenter = null;
        rethrow;
      }
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
