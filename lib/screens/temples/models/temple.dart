import 'package:google_maps_flutter/google_maps_flutter.dart';

class TempleModel {
  final String name;
  final String address;
  final LatLng latLng;
  // final double distance;

  TempleModel({
    required this.name,
    required this.address,
    required this.latLng,
    // required this.distance,
  });
}
