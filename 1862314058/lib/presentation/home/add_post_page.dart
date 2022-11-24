import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/choice_icon.dart';
import '../../data/post.dart';
import '../../widgets/choose_icon_widget.dart';
import 'home_state.dart';

class AddPostPage extends StatefulWidget {
  final Post? postItem;

  const AddPostPage({super.key, this.postItem});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _postTitle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 70, 20, 10),
        child: Column(
          children: [
            Column(
              children: [
                const Text(
                  'Create a new Page',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _postTitle,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name of the Page',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                children: List.generate(choices.length, (index) {
                  return Center(
                    child: ChooseIcon(
                      choiceIcon: choices[index],
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
      floatingActionButton:
          BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
        return FloatingActionButton(
          onPressed: () {
            if (_postTitle.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error correct title'),
                ),
              );
            } else {
              var newPost = Post(title: _postTitle.text);
              context.read<HomeCubit>().addPost(newPost);
              _postTitle.clear();
              Navigator.pop(context);
            }
          },
          backgroundColor: Colors.amber,
          child: const Icon(Icons.add),
        );
      }),
    );
  }
}
