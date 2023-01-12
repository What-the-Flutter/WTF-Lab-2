import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/post.dart';
import '../../repository/anonymous_auth.dart';
import '../../widgets/info_post_widget.dart';
import '../bot/bot_page.dart';

import '../messages/messages_page.dart';
import 'add_post_page.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AuthService().currentUser!.uid,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 25,
                ),
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
                    icon: const Icon(
                      Icons.smart_toy,
                    ),
                    label: Text(
                      'Questionnaire bot',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: state.postList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagesPage(
                              item: state.postList[index],
                              index: index,
                            ),
                          ),
                        );
                      },
                      onLongPress: (() => {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 280,
                                  child: _buildPostBottomMenu(
                                    state.postList[index],
                                    index,
                                  ),
                                );
                              },
                            )
                          }),
                      child: ListTile(
                        trailing: Text(
                          state.postList[index].createPostTime.toString(),
                        ),
                        title: Text(
                          state.postList[index].title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text('No events'),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<HomeCubit>(context),
                child: const AddPostPage(
                  isEditMode: false,
                ),
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

  Column _buildPostBottomMenu(Post postItem, int index) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(
            Icons.info,
            color: Colors.green,
          ),
          title: const Text('Info'),
          onTap: () => _showPostInfo(postItem),
        ),
        ListTile(
          leading: const Icon(
            Icons.attach_file,
            color: Colors.lightGreen,
          ),
          title: const Text('Pin/Unpin Page'),
          onTap: () => context.read<HomeCubit>().pinPost(
                postItem,
                index,
              ),
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPostPage(
                  postItem: postItem,
                  isEditMode: true,
                  index: index,
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: const Text('Delete Page'),
          onTap: () => _showDeletePost(index),
        ),
      ],
    );
  }

  void _showPostInfo(Post postItem) {
    showDialog(
      context: context,
      builder: (_) => InfoPost(
        title: postItem.title,
        postIcon: Icons.add_a_photo,
        postCreated: postItem.createPostTime,
      ),
    );
  }

  void _showDeletePost(int index) {
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Are you sure you want to delete this page?',
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  context.read<HomeCubit>().deletePost(index);
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
      },
    );
  }
}
