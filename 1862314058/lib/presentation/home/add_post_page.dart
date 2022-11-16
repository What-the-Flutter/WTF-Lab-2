import 'package:flutter/material.dart';

import '../../widgets/choose_icon_widget.dart';

class AddPostPage extends StatefulWidget {
  final Function(String) addPost;

  const AddPostPage({super.key, required this.addPost});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController postTitle = TextEditingController();

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
                  controller: postTitle,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (postTitle.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error correct title'),
              ),
            );
          } else {
            widget.addPost(postTitle.text);
            Navigator.pop(context);
          }
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ChoiceIcon {
  final IconData icon;

  const ChoiceIcon({required this.icon});
}

const List<ChoiceIcon> choices = [
  ChoiceIcon(icon: Icons.text_fields),
  ChoiceIcon(icon: Icons.directions_walk),
  ChoiceIcon(icon: Icons.smoke_free),
  ChoiceIcon(icon: Icons.no_meals_outlined),
  ChoiceIcon(icon: Icons.directions_car),
  ChoiceIcon(icon: Icons.directions_bike),
  ChoiceIcon(icon: Icons.directions_walk),
  ChoiceIcon(icon: Icons.drafts),
  ChoiceIcon(icon: Icons.dvr),
  ChoiceIcon(icon: Icons.museum_outlined),
  ChoiceIcon(icon: Icons.music_note_outlined),
  ChoiceIcon(icon: Icons.copyright),
  ChoiceIcon(icon: Icons.monetization_on),
  ChoiceIcon(icon: Icons.directions_walk),
  ChoiceIcon(icon: Icons.smoke_free),
  ChoiceIcon(icon: Icons.no_meals_outlined),
  ChoiceIcon(icon: Icons.directions_car),
  ChoiceIcon(icon: Icons.directions_bike),
  ChoiceIcon(icon: Icons.directions_walk),
  ChoiceIcon(icon: Icons.drafts),
  ChoiceIcon(icon: Icons.dvr),
  ChoiceIcon(icon: Icons.museum_outlined),
  ChoiceIcon(icon: Icons.music_note_outlined),
  ChoiceIcon(icon: Icons.copyright),
  ChoiceIcon(icon: Icons.text_fields),
  ChoiceIcon(icon: Icons.directions_walk),
  ChoiceIcon(icon: Icons.smoke_free),
  ChoiceIcon(icon: Icons.no_meals_outlined),
  ChoiceIcon(icon: Icons.drafts),
  ChoiceIcon(icon: Icons.dvr),
  ChoiceIcon(icon: Icons.museum_outlined),
  ChoiceIcon(icon: Icons.music_note_outlined),
  ChoiceIcon(icon: Icons.copyright),
];
