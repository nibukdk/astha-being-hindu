import 'dart:convert';
import 'package:astha/screens/auth/utils/auth_utils.dart';
import 'package:astha/screens/temples/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

//
import 'package:astha/screens/temples/models/temple.dart';

class TempleProvider with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ViewState _viewState = ViewState.idle;

  final TemplesUtils templesUtils = TemplesUtils();
  // Create the fake list of temples
  List<TempleModel>? _temples;
  List? _resultList;
  LatLng? _userLocation;
  String? _errMsg;

  ViewState get viewState => _viewState;
  List<TempleModel> get temples => [..._temples as List];
  List get resultList => _resultList as List;
  LatLng get userLocation => _userLocation as LatLng;
  String get errMsg => _errMsg as String;

  void setViewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  Future<void> getNearyByTemples(LatLng userLocation) async {
    HttpsCallable getNearbyTemples =
        functions.httpsCallable('getNearbyTemples');
    Uri url = templesUtils.searchUrl(userLocation);
    try {
      setViewState(ViewState.busy);

      CollectionReference templeDocRef = firestore.collection('temples');
      QuerySnapshot querySnapshot = await templeDocRef.limit(1).get();

      if (querySnapshot.docs.isEmpty) {
        final res = await http.get(url);
        final decodedRes = await jsonDecode(res.body) as Map;
        final results = await decodedRes['results'] as List;
        final templesListCall = await getNearbyTemples.call(<String, List>{
          'templeList': [...results]
        });

        final newTempleLists = templesListCall.data['temples']
            .map(
              (temple) => TempleModel(
                name: temple['name'],
                address: temple['address'],
                latLng:
                    LatLng(temple['latLng']['lat'], temple['latLng']['lon']),
              ),
            )
            .toList();
        _temples = [...newTempleLists];
        setViewState(ViewState.idle);
      } else {
        try {
          setViewState(ViewState.busy);
          final tempSnapShot = await templeDocRef.get();
          final tempList = tempSnapShot.docs[0]['temples'] as List;
          final templesList = tempList
              .map(
                (temple) => TempleModel(
                  name: temple['name'],
                  address: temple['address'],
                  latLng:
                      LatLng(temple['latLng']['lat'], temple['latLng']['lon']),
                ),
              )
              .toList();
          _temples = [...templesList];
          setViewState(ViewState.idle);
        } catch (e) {
          _temples = [];
          setViewState(ViewState.idle);
        }
      }
    } catch (e) {
      _temples = [];
      setViewState(ViewState.idle);
    }

    notifyListeners();
  }
}
