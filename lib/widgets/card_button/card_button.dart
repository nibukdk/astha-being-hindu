import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final double width;

  CardButton(this.icon, this.title, this.width, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: SizedBox(
        width: width * .99,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              Expanded(
                flex: 2,
                child: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.background.withOpacity(0.5),
                  radius: 41,
                  child: IconButton(
                    icon: Icon(
                      icon,
                      size: 35,
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {},
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title),
                ),
              )
            ]),
      ),
    );
  }
}
