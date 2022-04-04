import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/event_category.dart';
import '../screens/chat_screen.dart';
import 'edit_category_dialog.dart';

class UnpinedCategory extends StatefulWidget {
  const UnpinedCategory({Key? key}) : super(key: key);

  @override
  State<UnpinedCategory> createState() => _UnpinedCategoryState();
}

class _UnpinedCategoryState extends State<UnpinedCategory> {
  final TextEditingController _controller = TextEditingController();
  
  final _user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
        padding: const EdgeInsets.all(5),
        query: FirebaseDatabase.instance
            .ref()
            .child(_user?.uid ?? '')
            .child('category')
            .orderByChild('pinned'),
        itemBuilder: (context, snapshot, animation, x) {
          var categoryList = Map.from(snapshot.value as Map);
          return GestureDetector(
            onTap: (() => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) =>
                        ChatScreen(categoryTitle: categoryList['title'])),
                  ),
                )),
            onLongPress: () {
              HapticFeedback.heavyImpact();
              displayTextInputDialog(
                  context: context,
                  category: EventCategory(
                    title: categoryList['title'],
                    pinned: categoryList['pinned'] == 1 ? false : true,
                    icon: const Icon(Icons.ads_click),
                  ),
                  pinned: categoryList['pinned'] == 1 ? false : true,
                  key: snapshot.key!);
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                child: Icon(
                  IconData(categoryList['icon'], fontFamily: 'MaterialIcons'),
                ),
              ),
              title: Text(categoryList['title']),
              subtitle: Text(categoryList['pinned'].toString()),
              trailing: Icon(
                Icons.push_pin_rounded,
                color: categoryList['pinned'] == 1
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).primaryColor,
              ),
            ),
          );
        });
  }
}
