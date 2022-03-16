import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class TemplesUtils {
  static const String _baseUrlNearBySearch =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?";
  final String _placesApi = dotenv.env['GMAP_PLACES_API_KEY_ANDROID'] as String;

  Uri searchUrl(LatLng userLocation) {
    final api = "&key=$_placesApi";
    final location =
        "location=${userLocation.latitude},${userLocation.longitude}";
    const type = "&type=hindu_temple";
    // const radius = "&radius=50000";
    const rankBy = "&rankby=distance";
    final url =
        Uri.parse(_baseUrlNearBySearch + location + rankBy + type + api);

    return url;
  }

  double calcuateDisatance(LatLng pointOne, LatLng pointTwo) {
    // Calculate distance between two points from user to temple
    // radius of earth in KM
    const radius = 6371;
    final double lon1 = pointOne.longitude * pi / 180;
    final double lat1 = pointOne.latitude * pi / 180;
    final double lon2 = pointTwo.longitude * pi / 180;
    final double lat2 = pointTwo.latitude * pi / 180;

    // Diffence is two points
    final double dlon = lon1 - lon2;
    final double dlat = lat1 - lat2;

    final a =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distance in meters
    final haverDistance = radius * c;
    return haverDistance;
  }
}
