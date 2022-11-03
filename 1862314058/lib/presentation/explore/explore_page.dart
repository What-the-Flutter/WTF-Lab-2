import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const <Widget>[
            SizedBox(
              height: 300,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Placeholder(),
              ),
            ),
            SizedBox(
              height: 50,
              child: Padding(
                padding: EdgeInsets.fromLTRB(80, 5, 80, 5),
                child: Placeholder(),
              ),
            ),
            SizedBox(
              height: 150,
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
