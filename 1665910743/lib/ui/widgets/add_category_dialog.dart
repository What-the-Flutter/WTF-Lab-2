import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/event_categyory.dart';
import '../../models/icons_pack.dart';

Future<dynamic> addTaskDialog(BuildContext context) {
  return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white.withOpacity(0.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.95,
      ),
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ModalBody(),
          ),
        );
      });
}

class ModalBody extends StatefulWidget {
  final controller = TextEditingController();
  ModalBody({Key? key}) : super(key: key);

  @override
  State<ModalBody> createState() => _ModalBodyState();
}

class _ModalBodyState extends State<ModalBody> {
  bool isSelected = false;
  int selectedIndexAvatar = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.95),
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      height: MediaQuery.of(context).size.height * 0.43,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 20.0,
          left: 20,
          top: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: CupertinoTextField(
                      placeholder: 'Enter the name',
                      controller: widget.controller,
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (selectedIndexAvatar == -1) {
                        setState(
                          () {
                            context.read<CategoryList>().add(
                                  EventCategory(
                                    widget.controller.text,
                                    false,
                                    kMyIcons[7],
                                  ),
                                );
                            Navigator.pop(context);
                          },
                        );
                      } else {
                        setState(
                          () {
                            context.read<CategoryList>().add(
                                  EventCategory(
                                    widget.controller.text,
                                    false,
                                    kMyIcons[selectedIndexAvatar],
                                  ),
                                );
                            Navigator.pop(context);
                          },
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.30),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 120,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: kMyIcons.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected = !isSelected;
                        selectedIndexAvatar = i;
                        print(selectedIndexAvatar.toString());
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: (selectedIndexAvatar == i)
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      radius: MediaQuery.of(context).size.width * 0.13,
                      child: CategoryIconButton(
                        icon: kMyIcons[i],
                        size: MediaQuery.of(context).size.width * 0.13,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
