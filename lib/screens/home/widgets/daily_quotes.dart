import 'package:flutter/material.dart';

class DailyQuotes extends StatelessWidget {
  final double height;
  final double width;
  const DailyQuotes(this.height, this.width, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * .99,
      height: 150,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      child: Card(
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        "Bhagavad Gita",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        "Calmness, gentleness, silence, self-restraint, and purity: these are the disciplines of the mind.",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  child: Image.asset(
                    "assets/images/image_3.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
