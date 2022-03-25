import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/database_provider.dart';
import '../../models/chat.dart';
import '../../models/event.dart';
import '../../themes/inherited_theme.dart';
import '../new_category_page/new_category_page.dart';
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
  late final HomeCubit _cubit;
  //late final List<Event> events;

  @override
  void initState() {
    _cubit = BlocProvider.of<HomeCubit>(context);
    _cubit.init();
    //events = await DatabaseProvider.db.getEvents();
    super.initState();
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
            onPressed: (() => Inherited.of(context).changeTheme()),
            icon: const Icon(Icons.invert_colors),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
        ],
      ),
      drawer: Drawer(backgroundColor: Theme.of(context).primaryColor),
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: _cubit,
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

  Future<List<Event>> getEvents() async {
    return await DatabaseProvider.db.getEvents();
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
              return Column(
                children: [
                  Divider(
                    height: 5,
                    thickness: 5,
                    color: Theme.of(context).shadowColor,
                  ),
                  HoveredItem(
                    state.listOfChats[index].category,
                    'No events. Click to create one.',
                    state.listOfChats[index].icon.icon!,
                    _bottomSheet(
                      context,
                      state.listOfChats[index].category,
                      state.listOfChats[index].icon,
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
      _cubit.addChat(res.first);
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
    _cubit.addChat(res.first);
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
        _cubit.remove(title);
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
}
