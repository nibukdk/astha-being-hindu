import 'package:flutter/material.dart';

class TempleItemWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String address;
  // final double width;
  // final double height;

  // final String establishedDate;

  const TempleItemWidget(
      {required this.title,
      required this.imageUrl,
      required this.address,
      // required this.height,
      // required this.width,

      // required this.establishedDate,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: 400,
                height: 150,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headline3,
              // softWrap: true,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
