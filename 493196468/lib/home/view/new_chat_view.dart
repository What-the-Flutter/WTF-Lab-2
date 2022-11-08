import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';
import '../home_entity/chat_card.dart';

class NewChatView extends StatefulWidget {
  const NewChatView({Key? key}) : super(key: key);

  @override
  State<NewChatView> createState() => _NewChatViewState();
}

class _NewChatViewState extends State<NewChatView> {
  final _icons = [
    Icons.cake,
    Icons.add_location_sharp,
    Icons.zoom_in_outlined,
    Icons.auto_awesome_motion,
    Icons.call_end_sharp,
    Icons.equalizer_rounded,
    Icons.wifi_lock,
    Icons.mail,
    Icons.add,
    Icons.search,
    Icons.close,
  ];

  final _textFormKey = GlobalKey<FormState>();
  var _text = '';
  var _iconIndex = -1;
  @override
  Widget build(BuildContext context) {

    int anySelected = context
        .read<HomeCubit>()
        .state
        .indexWhere((element) => element.isSelected);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: _text.isEmpty
            ? const Icon(Icons.cancel_outlined)
            : const Icon(Icons.add),
        onPressed: () {
          if(anySelected != -1) {
            context.read<HomeCubit>().editChat(_text);
          } else {
            context.read<HomeCubit>().addChat(
              newChatCard: ChatCard(
                icon: Icon(_icons[_iconIndex]),
                title: _text,
              ),
            );
          }
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: const Text(
                'Create a new Page',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Form(
              key: _textFormKey,
              child: TextFormField(
                initialValue: anySelected != -1 ? context.read<HomeCubit>().state[anySelected].title : null,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColorLight,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColorLight,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColorLight,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value != null) {
                    return value.isEmpty ? 'Message is empty' : null;
                  } else {
                    return 'Message is empty';
                  }
                },
                onChanged: (value) {
                  _text = value;
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: _icons.length,
                itemBuilder: (context, index) {
                  return IconButton(
                    onPressed: () {
                      _iconIndex = index;
                      setState(() {});
                    },
                    icon: index == _iconIndex
                        ? Icon(
                            _icons[index],
                            color: Colors.black,
                          )
                        : Icon(
                            _icons[index],
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
