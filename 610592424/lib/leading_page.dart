import 'package:diploma/animation_page/animation_rive_view.dart';
import 'package:diploma/home_page/event_holder_screen/eventholder_page.dart';
import 'package:diploma/home_page/settings_screen/settings_cubit.dart';
import 'package:diploma/timeline_page/timeline_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeadingPage extends StatefulWidget {
  const LeadingPage({Key? key}) : super(key: key);

  @override
  State<LeadingPage> createState() => _LeadingPageState();
}

class _LeadingPageState extends State<LeadingPage> {
  late int _currentIndex;
  late Widget _body;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _body = const EventHolderPage();
    BlocProvider.of<SettingsCubit>(context).loadTheme();
  }

  void _changePage(int newIndex) {
    assert(newIndex >= 0);
    _currentIndex = newIndex;
    setState(() {
      switch(_currentIndex){
        case 0:
          _body = const EventHolderPage();
          break;
        case 1:
          _body = const TimelinePage();
          break;
        case 2:
          _body = const MyRiveAnimation();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body,
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
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
      currentIndex: _currentIndex,
      selectedItemColor: Colors.amber[800],
      onTap: (index) => _changePage(index),
    );
  }
}
