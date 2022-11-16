import 'package:flutter/material.dart';

import '../../widgets/info_post_widget.dart';
import '../bot/bot_page.dart';
import '../messages/messages_page.dart';
import 'add_post_page.dart';

class HomePage extends StatefulWidget {
  final List<String> postList = ['1', '2', '3'];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void addPost(String title) {
    setState(() {
      widget.postList.add(title);
    });
  }

  void deletePost(int index) {
    setState(() {
      widget.postList.removeAt(index);
      Navigator.pop(context);
    });
  }

  void pinPost(int index) {
    setState(() {
      if (index == 0) {
        widget.postList.insert(3, widget.postList[index].toString());
        widget.postList.removeAt(0);
      } else {
        widget.postList.insert(0, widget.postList[index].toString());
        widget.postList.removeAt(index + 1);
      }
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
                minHeight: 50,
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BotPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.smart_toy),
                label: const Text('Questionnaire bot'),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: widget.postList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagesPage(
                            item: widget.postList[index],
                            index: index,
                          ),
                        ),
                      );
                    },
                    onLongPress: () => _postBottomSheet(index),
                    child: ListTile(
                      leading: const Icon(Icons.book),
                      title: Text(
                        widget.postList[index].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('No events'),
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPostPage(
                addPost: addPost,
              ),
            ),
          );
        },
        tooltip: 'New Page',
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }

  _postBottomSheet(int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 280,
            child: _buildPostBottomMenu(index),
          );
        });
  }

  Column _buildPostBottomMenu(int index) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(
            Icons.info,
            color: Colors.green,
          ),
          title: const Text('Info'),
          onTap: () => showPostInfo(index),
        ),
        ListTile(
          leading: const Icon(
            Icons.attach_file,
            color: Colors.lightGreen,
          ),
          title: const Text('Pin/Unpin Page'),
          onTap: () => pinPost(index),
        ),
        ListTile(
          leading: const Icon(
            Icons.archive,
            color: Colors.yellow,
          ),
          title: const Text('Archive Page'),
          onTap: () => print('ok'),
        ),
        ListTile(
          leading: const Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          title: const Text('Edit Page'),
          onTap: () => print('ok'),
        ),
        ListTile(
          leading: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: const Text('Delete Page'),
          onTap: () => showDeletePost(index),
        ),
      ],
    );
  }

  showPostInfo(int index) {
    showDialog(
      context: context,
      builder: (_) => InfoPost(
          title: widget.postList[index].toString(),
          postIcon: Icons.add_a_photo),
    );
  }

  showDeletePost(int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Delete Page?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Are you sure you want to delete this page?'),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () {
                    deletePost(index);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('Cancel'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }
}
