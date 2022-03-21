import 'dart:convert';
import 'dart:math';
import 'package:astha/screens/auth/utils/auth_utils.dart';
import 'package:astha/screens/temples/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firbaseStorage;
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

//
import 'package:astha/screens/temples/models/temple.dart';

class TempleProvider with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final firbaseStorage.FirebaseStorage storage =
      firbaseStorage.FirebaseStorage.instanceFor(
          bucket: 'being-hindu-308f9.appspot.com');

  ViewState _viewState = ViewState.idle;

  final TemplesUtils templesUtils = TemplesUtils();
  // Create the fake list of temples
  List<TempleModel>? _temples = [];
  List? _resultList;
  LatLng? _userLocation;
  String? _errMsg;

  // ViewState get viewState => _viewState;
  List<TempleModel> get temples => [..._temples as List];
  List get resultList => _resultList as List;
  LatLng get userLocation => _userLocation as LatLng;
  String get errMsg => _errMsg as String;
  ViewState get viewState => _viewState;

  static const List<String> imagePaths = [
    'image_1.jpg',
    'image_2.jpg',
    'image_3.jpg',
    'image_4.jpg',
  ];

  void setViewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  Future<void> getNearyByTemples(LatLng userLocation) async {
    Uri url = templesUtils.searchUrl(userLocation);

    try {
      // Set up references for firebase products.
      HttpsCallable getNearbyTemples =
          functions.httpsCallable('getNearbyTemples');
      CollectionReference templeDocRef = firestore.collection('temples');
      QuerySnapshot querySnapshot = await templeDocRef.limit(1).get();
      firbaseStorage.Reference storageRef = storage.ref('TempleImages');

      if (querySnapshot.docs.isEmpty) {
        print("Temple collection is empty");
        final res = await http.get(url);
        final decodedRes = await jsonDecode(res.body) as Map;
        final results = await decodedRes['results'] as List;
        // Get random image url from available ones to put as images
        // Since we have 4 images we'll get 0-3 values from Random()
        final imgUrl = await storageRef
            .child(imagePaths[Random().nextInt(4)])
            .getDownloadURL();
        // print(imgUrl);
        final templesListCall = await getNearbyTemples.call(<String, dynamic>{
          'templeList': [...results],
          'imageRef': imgUrl,
        });

        final newTempleLists = templesListCall.data['temples']
            .map(
              (temple) => TempleModel(
                name: temple['name'],
                address: temple['address'],
                latLng: LatLng(
                  temple['latLng']['lat'],
                  temple['latLng']['lon'],
                ),
                imageUrl: temple['imageRef'],
                placesId: temple['place_id'],
              ),
            )
            .toList();
        _temples = [...newTempleLists];
      } else {
        print("Temple collection is not empty");

        try {
          final tempSnapShot = await templeDocRef.get();
          final tempList = tempSnapShot.docs[0]['temples'] as List;
          final templesList = tempList
              .map(
                (temple) => TempleModel(
                  name: temple['name'],
                  address: temple['address'],
                  latLng: LatLng(
                    temple['latLng']['lat'],
                    temple['latLng']['lon'],
                  ),
                  imageUrl: temple['imageRef'],
                  placesId: temple['place_id'],
                ),
              )
              .toList();
          _temples = [...templesList];
        } catch (e) {
          _temples = [];
          // setViewState(ViewState.idle);
        }
      }
      // setViewState(ViewState.idle);
    } catch (e) {
      _temples = [];
      // setViewState(ViewState.idle);
    }

    notifyListeners();
  }
}
