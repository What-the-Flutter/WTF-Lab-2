import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/icons.dart';
import '../../models/chat.dart';
import '../new_category_page/new_category_page.dart';
import '../settings_page/settings_cubit.dart';
import '../settings_page/settings_page.dart';
import 'home_cubit.dart';
import 'home_state.dart';
import 'widgets/hovered_item.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeCubit _homeCubit;
  late final SettingsCubit _settingsCubit;

  @override
  void initState() {
    super.initState();

    _homeCubit = BlocProvider.of<HomeCubit>(context);
    _settingsCubit = BlocProvider.of<SettingsCubit>(context);

    _homeCubit.init();
    _settingsCubit.loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 25),
      primary: Theme.of(context).primaryColor,
      minimumSize: const Size(200, 40),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _settingsCubit.changeTheme,
            icon: const Icon(Icons.invert_colors),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
        ],
      ),
      drawer: _drawer(),
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: _homeCubit,
        builder: (context, state) {
          return _body(style, state);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () => {
          _createChat(context),
        },
        tooltip: 'Button',
        child: const Icon(
          Icons.add,
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  Widget _body(ButtonStyle style, HomeState state) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 40),
        ),
        botButton(style, context),
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: state.listOfChats.length,
            itemBuilder: (context, index) {
              var events = state.events.where(
                (element) =>
                    element.category == state.listOfChats[index].category,
              );
              return Column(
                children: [
                  Divider(
                    height: 5,
                    thickness: 5,
                    color: Theme.of(context).shadowColor,
                  ),
                  HoveredItem(
                    state.listOfChats[index].category,
                    events.isEmpty
                        ? 'No events. Tap to create one.'
                        : events.last.description,
                    icons.elementAt(state.listOfChats[index].icon).icon!,
                    _bottomSheet(
                      context,
                      state.listOfChats[index].category,
                      icons.elementAt(state.listOfChats[index].icon),
                      state,
                    ),
                    state.events,
                  ),
                  Divider(
                    height: 5,
                    thickness: 5,
                    color: Theme.of(context).shadowColor,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _createChat(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewCategoryPage(),
      ),
    );
    if (result != null) {
      var res = List<Chat>.from(result);
      _homeCubit.addChat(res.first);
    }
  }

  Widget botButton(ButtonStyle style, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: style,
          onPressed: () {},
          icon: Icon(
            Icons.question_answer,
            size: 30.0,
            color: Theme.of(context).highlightColor,
          ),
          label: Text(
            'Questionnaire Bot',
            style: TextStyle(color: Theme.of(context).highlightColor),
          ),
        ),
      ],
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).bottomAppBarColor,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        )
      ],
    );
  }

  void _editChat(
      BuildContext context, String title, Icon icon, HomeState state) async {
    Navigator.pop(context);
    state.listOfChats.removeWhere(
        (element) => element.category == title && element.icon == icon);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewCategoryPage.edit(
          title: title,
          icon: icon,
        ),
      ),
    );

    var res = List<Chat>.from(result);
    _homeCubit.addChat(res.first);
  }

  Widget _infoButton() {
    return TextButton(
      child: Row(children: [
        const Icon(
          Icons.info,
          color: Color.fromARGB(255, 3, 201, 125),
        ),
        const Padding(
          padding: EdgeInsets.all(5),
        ),
        Text(
          'Info',
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).hintColor,
          ),
        ),
      ]),
      onPressed: null,
    );
  }

  Widget _pinPageButton() {
    return TextButton(
      child: Row(children: [
        const Icon(
          Icons.attach_file,
          color: Colors.green,
        ),
        const Padding(
          padding: EdgeInsets.all(5),
        ),
        Text(
          'Pin/Unpin page',
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).hintColor,
          ),
        ),
      ]),
      onPressed: null,
    );
  }

  Widget _archieveButton() {
    return TextButton(
      child: Row(children: [
        const Icon(
          Icons.archive,
          color: Colors.yellow,
        ),
        const Padding(
          padding: EdgeInsets.all(5),
        ),
        Text(
          'Archive page',
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).hintColor,
          ),
        ),
      ]),
      onPressed: null,
    );
  }

  Widget _editPageButton(String title, Icon icon, HomeState state) {
    return TextButton(
      child: Row(children: [
        const Icon(
          Icons.edit,
          color: Colors.blue,
        ),
        const Padding(
          padding: EdgeInsets.all(5),
        ),
        Text(
          'Edit page',
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).hintColor,
          ),
        ),
      ]),
      onPressed: () => _editChat(context, title, icon, state),
    );
  }

  Widget _deletePageButton(String title) {
    return TextButton(
      child: Row(children: [
        const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        const Padding(
          padding: EdgeInsets.all(5),
        ),
        Text(
          'Delete page',
          style: TextStyle(fontSize: 25, color: Theme.of(context).hintColor),
        ),
      ]),
      onPressed: () {
        Navigator.pop(context);
        _homeCubit.remove(title);
      },
    );
  }

  Widget _bottomSheet(
    BuildContext context,
    String title,
    Icon icon,
    HomeState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(5),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _infoButton(),
          _pinPageButton(),
          _archieveButton(),
          _editPageButton(title, icon, state),
          _deletePageButton(title),
        ],
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        children: [
          SizedBox(
            height: 145,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chats Journal',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).highlightColor,
                  ),
                ),
              ),
            ),
          ),
          const ListTile(
            title: Text('Search'),
            leading: Icon(Icons.search),
          ),
          const ListTile(
            title: Text('Notifications'),
            leading: Icon(Icons.notifications),
          ),
          const ListTile(
            title: Text('Statistics'),
            leading: Icon(Icons.timeline),
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsPage(
                  title: 'Theme',
                ),
              ),
            ),
          ),
          const ListTile(
            title: Text('Feedback'),
            leading: Icon(Icons.mail),
          ),
        ],
      ),
    );
  }
}
