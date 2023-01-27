import 'rive_model.dart';

class Menu {
  final String title;
  final RiveModel rive;

  Menu({
    required this.title,
    required this.rive,
  });
}

List<Menu> bottomNavItems = [
  Menu(
    title: 'Home',
    rive: RiveModel(
        src: 'assets/icons.riv',
        artboard: 'HOME',
        stateMachineName: 'HOME_interactivity'),
  ),
  Menu(
    title: 'Chat',
    rive: RiveModel(
        src: 'assets/icons.riv',
        artboard: 'CHAT',
        stateMachineName: 'CHAT_Interactivity'),
  ),
  Menu(
    title: 'Timer',
    rive: RiveModel(
        src: 'assets/icons.riv',
        artboard: 'TIMER',
        stateMachineName: 'TIMER_Interactivity'),
  ),
  Menu(
    title: 'Search',
    rive: RiveModel(
        src: 'assets/icons.riv',
        artboard: 'SEARCH',
        stateMachineName: 'SEARCH_Interactivity'),
  ),
];
