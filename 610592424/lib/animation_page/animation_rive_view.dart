import 'package:diploma/homePage/event_holder_screen/eventholder_page.dart';
import 'package:diploma/timeline_page/timeline_page.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class MyRiveAnimation extends StatefulWidget {
  const MyRiveAnimation({Key? key}) : super(key: key);

  @override
  _MyRiveAnimationState createState() => _MyRiveAnimationState();
}

class _MyRiveAnimationState extends State<MyRiveAnimation> {
  // Controller for playback
  late RiveAnimationController _controller;

  // Toggles between play and pause animation states
  void _togglePlay() =>
      setState(() => _controller.isActive = !_controller.isActive);

  /// Tracks if the animation is playing by whether controller is running
  bool get isPlaying => _controller.isActive;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('idle');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RiveAnimation.network(
          'https://cdn.rive.app/animations/vehicles.riv',
          controllers: [_controller],
          // Update the play state when the widget's initialized
          onInit: (_) => setState(() {}),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlay,
        tooltip: isPlaying ? 'Pause' : 'Play',
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman),
            label: 'Animation',
          ),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          if(index == 0){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const EventHolderPage();
                },
              ),
            );
          }
          else if(index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const TimelinePage();
                },
              ),
            );
          }
        },
      ),
    );
  }
}