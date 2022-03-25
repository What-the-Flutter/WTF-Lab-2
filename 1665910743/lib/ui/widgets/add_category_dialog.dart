import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/categorylist_cubit.dart';
import '../../cubit/categorylist_state.dart';
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ModalBody(),
        ),
      );
    },
  );
}

class ModalBody extends StatefulWidget {
  ModalBody({Key? key}) : super(key: key);

  @override
  State<ModalBody> createState() => _ModalBodyState();
}

class _ModalBodyState extends State<ModalBody> {
  final controller = TextEditingController();
  bool _isSelected = false;
  int _selectedIndexAvatar = -1;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;
    return BlocBuilder<CategorylistCubit, CategoryListState>(
      bloc: CategorylistCubit(),
      builder: ((context, state) => Container(
            constraints: BoxConstraints(maxHeight: _screenSize.height * 0.95),
            margin: EdgeInsets.only(top: _screenSize.height * 0.05),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            height: _screenSize.height * 0.45,
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                          width: _screenSize.width * 0.7,
                          child: CupertinoTextField(
                            placeholder: 'Enter the name',
                            controller: controller,
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_selectedIndexAvatar == -1) {
                              context
                                  .read<CategorylistCubit>()
                                  .add(EventCategory(
                                    controller.text,
                                    false,
                                    kMyIcons[7],
                                  ));
                              Navigator.pop(
                                context,
                              );
                            } else {
                              context
                                  .read<CategorylistCubit>()
                                  .add(EventCategory(
                                    controller.text,
                                    false,
                                    kMyIcons[_selectedIndexAvatar],
                                  ));
                              Navigator.pop(
                                context,
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
                    height: _screenSize.height * 0.02,
                  ),
                  Container(
                    constraints:
                        BoxConstraints(maxHeight: _screenSize.height * 0.30),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 120,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: kMyIcons.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                _isSelected = !_isSelected;
                                _selectedIndexAvatar = i;
                              },
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: (_selectedIndexAvatar == i)
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                            radius: _screenSize.width * 0.13,
                            child: CategoryIconButton(
                              icon: kMyIcons[i],
                              size: _screenSize.width * 0.13,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
