import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/choice_icon.dart';
import '../../data/models/post.dart';
import '../../widgets/choose_icon_widget.dart';
import 'home_state.dart';

class AddPostPage extends StatefulWidget {
  final Post? postItem;
  final bool isEditMode;
  final int? index;

  const AddPostPage({
    super.key,
    this.postItem,
    required this.isEditMode,
    this.index,
  });

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _postTitle = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      _postTitle.text = widget.postItem!.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 70, 20, 10),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  widget.isEditMode ? 'Edit Page' : 'Create a new Page',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
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
                children: List.generate(
                  choices.length,
                  (index) {
                    return Center(
                      child: ChooseIcon(
                        choiceIcon: choices[index],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: widget.isEditMode ? updateData : submitData,
            backgroundColor: Colors.amber,
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  void updateData() {
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toInt(),
      title: _postTitle.text,
      createPostTime: DateFormat.yMd().format(DateTime.now()).toString(),
    );
    context.read<HomeCubit>().editPost(newPost, widget.index!);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void submitData() {
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toInt(),
      title: _postTitle.text,
      createPostTime: DateFormat.yMd().format(DateTime.now()).toString(),
    );
    context.read<HomeCubit>().addPost(newPost);
    _postTitle.clear();
    Navigator.pop(context);
  }
}
