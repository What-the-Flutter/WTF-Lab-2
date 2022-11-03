import 'package:flutter/material.dart';

class DailyPage extends StatelessWidget {
  const DailyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const <Widget>[
            SizedBox(
              height: 60,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Placeholder(),
              ),
            ),
            SizedBox(
              height: 60,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Placeholder(),
              ),
            ),
            SizedBox(
              height: 350,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Placeholder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
