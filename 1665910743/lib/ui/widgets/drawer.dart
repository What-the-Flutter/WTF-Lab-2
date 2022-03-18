import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JourneyDrawer extends StatelessWidget {
  
  const JourneyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Align(
              alignment: FractionalOffset.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 20.0),
                child: Text(
                  DateFormat.yMMMMd().format(DateTime.now()).toString(),
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
        )
      ],
      ),
    );
  }
}
