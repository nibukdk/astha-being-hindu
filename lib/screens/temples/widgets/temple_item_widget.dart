import 'package:astha/screens/auth/provider/auth_state_provider.dart';
import 'package:astha/screens/auth/utils/auth_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TempleItemWidget extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String address;
  final double width;
  final double height;
  final ViewState viewState;
  final String itemId;

  // final String establishedDate;

  const TempleItemWidget(
      {required this.title,
      required this.imageUrl,
      required this.address,
      required this.height,
      required this.width,
      required this.viewState,
      required this.itemId,

      // required this.establishedDate,
      Key? key})
      : super(key: key);

  @override
  State<TempleItemWidget> createState() => _TempleItemWidgetState();
}

class _TempleItemWidgetState extends State<TempleItemWidget> {
  bool isFav = false;
  late AuthStateProvider authStateProvider;

  @override
  void initState() {
    authStateProvider = AuthStateProvider();
    super.initState();
  }

  void toggleFavList(String placeId) {
    authStateProvider.addToFavList(placeId);
  }

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> qSnapShot = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return SizedBox(
      height: 260,
      width: widget.width * .9,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    width: 400,
                    height: 190,
                  ),
                ),
                Positioned(
                  bottom: 1,
                  child: Container(
                    color: Colors.black54,
                    width: widget.width * 1,
                    height: 25,
                    child: Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.white),
                      // softWrap: true,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        print("Donate Button Pressed");
                      },
                      icon: Icon(
                        Icons.attach_money,
                        color: Colors.yellow[700],
                      ),
                    ),
                  ),
                  StreamBuilder(
                      stream: qSnapShot,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          final docData = snapshot.data as DocumentSnapshot;
                          final favList = docData['favTempleList'] as List;
                          final isFav = favList.contains(widget.itemId);
                          return Expanded(
                            child: IconButton(
                                onPressed: () => toggleFavList(
                                      widget.itemId,
                                    ),
                                icon: Icon(
                                  Icons.favorite,
                                  color: isFav ? Colors.red : Colors.grey,
                                )),
                          );
                        }
                      })
                ]),
          ],
        ),
      ),
    );
  }
}
