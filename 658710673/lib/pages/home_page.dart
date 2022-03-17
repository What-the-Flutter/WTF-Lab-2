import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/main_page_widgets/main_bottom_bar.dart';
import '../widgets/main_page_widgets/main_event_card.dart';

class ChatJournalApp extends StatelessWidget {
  const ChatJournalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat journal',
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 190,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            title: const Center(
              child: Text('Home'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.invert_colors),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/app_bar_bg.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                return const EventCard(
                  title: 'Journal',
                  subtitle: 'No events. Click to create one.',
                  icon: Icons.book,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Constants.primaryColor,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const MainBottomBar(),
    );
  }
}
