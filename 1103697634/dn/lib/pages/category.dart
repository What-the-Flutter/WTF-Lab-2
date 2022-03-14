import 'dart:io';

import 'package:dn/models/Message.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/pageargs.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);
  static const routeName = '/extractArguments';

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  var messages = <Message>[];
  var id = 0;
  var selectedMessages = <int>[];
  var favoriteMessages = <int>[];
  bool isShowFavorites = false;
  bool isEditing = false;
  File? fileImage;
  ScrollController listScrollController = ScrollController();
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PageArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
        centerTitle: true,
        actions: [
          selectedMessages.isNotEmpty
              ? selectedMessages.length > 1
                  ? Row(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.copy),
                          tooltip: 'Copy',
                          onPressed: () {
                            setState(() {
                              String copiedText = "";
                              for (var element in selectedMessages) {
                                copiedText += " ";
                                copiedText += messages
                                    .firstWhere((item) => item.id == element)
                                    .text;
                              }
                              Clipboard.setData(
                                  ClipboardData(text: copiedText));
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Delete',
                          onPressed: () {
                            setState(() {
                              for (var element in selectedMessages) {
                                favoriteMessages.remove(element);
                                messages
                                    .removeWhere((item) => element == item.id);
                              }
                              selectedMessages.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Deleted'),
                                ),
                              );
                            });
                          },
                        )
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.copy),
                          tooltip: 'Copy',
                          onPressed: () {
                            setState(() {
                              String copiedText = "";
                              for (var element in selectedMessages) {
                                copiedText += " ";
                                copiedText += messages
                                    .firstWhere((item) => item.id == element)
                                    .text;
                              }
                              Clipboard.setData(
                                  ClipboardData(text: copiedText));
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit',
                          onPressed: () {
                            setState(() {
                              isEditing ? isEditing = false : isEditing = true;
                              isEditing
                                  ? textController.text = messages
                                      .firstWhere((element) =>
                                          selectedMessages[0] == element.id)
                                      .text
                                  : textController.clear();
                              isEditing
                                  ? fileImage = messages
                                      .firstWhere((element) =>
                                          selectedMessages[0] == element.id)
                                      .photo
                                  : fileImage = null;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Delete',
                          onPressed: () {
                            setState(() {
                              for (var element in selectedMessages) {
                                favoriteMessages.remove(element);
                                messages
                                    .removeWhere((item) => element == item.id);
                              }
                              selectedMessages.clear();
                              isEditing = false;
                              textController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Deleted'),
                                ),
                              );
                            });
                          },
                        )
                      ],
                    )
              : IconButton(
                  icon: isShowFavorites
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  tooltip: 'Favorite',
                  onPressed: () {
                    setState(() {
                      favoriteMessages.sort();
                      isShowFavorites
                          ? isShowFavorites = false
                          : isShowFavorites = true;
                    });
                  },
                ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
        itemCount: isShowFavorites ? favoriteMessages.length : messages.length,
        addRepaintBoundaries: false,
        controller: listScrollController,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            child: ListTile(
              subtitle: Bubble(
                color: isShowFavorites
                    ? selectedMessages.contains(favoriteMessages[index])
                        ? const Color(0xFFAABB97)
                        : const Color(0xFFDCEDC8)
                    : selectedMessages.contains(messages[index].id)
                        ? const Color(0xFFAABB97)
                        : const Color(0xFFDCEDC8),
                child: isShowFavorites
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  messages
                                      .firstWhere((element) =>
                                          favoriteMessages[index] == element.id)
                                      .text,
                                  textScaleFactor: 1.3),
                              if (messages
                                      .firstWhere((element) =>
                                          favoriteMessages[index] == element.id)
                                      .photo !=
                                  null)
                                Image.file(
                                  messages
                                      .firstWhere((element) =>
                                          favoriteMessages[index] == element.id)
                                      .photo!,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                            child: Icon(Icons.favorite_border, size: 13),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(messages[index].text, textScaleFactor: 1.3),
                              if (messages[index].photo != null)
                                Image.file(
                                  messages[index].photo!,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                            ],
                          ),
                          if(favoriteMessages.contains(messages[index].id))
                          const Padding(
                            padding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                            child: Icon(Icons.favorite_border, size: 13),
                          ),
                        ],
                      ),
                alignment: Alignment.bottomLeft,
                padding: const BubbleEdges.all(10),
              ),
              onLongPress: () {
                setState(() {
                  isShowFavorites
                      ? selectedMessages.contains(favoriteMessages[index])
                          ? selectedMessages.remove(favoriteMessages[index])
                          : selectedMessages.add(favoriteMessages[index])
                      : selectedMessages.contains(messages[index].id)
                          ? selectedMessages.remove(messages[index].id)
                          : selectedMessages.add(messages[index].id);
                });
              },
              onTap: isShowFavorites
                  ? selectedMessages.isNotEmpty
                      ? () {
                          setState(() {
                            isEditing = false;
                            textController.clear();
                            fileImage = null;
                            selectedMessages.contains(favoriteMessages[index])
                                ? selectedMessages
                                    .remove(favoriteMessages[index])
                                : selectedMessages.add(favoriteMessages[index]);
                          });
                        }
                      : () {
                          setState(() {
                            favoriteMessages.contains(favoriteMessages[index])
                                ? favoriteMessages
                                    .remove(favoriteMessages[index])
                                : favoriteMessages.add(favoriteMessages[index]);
                          });
                        }
                  : selectedMessages.isNotEmpty
                      ? () {
                          setState(() {
                            isEditing = false;
                            textController.clear();
                            fileImage = null;
                            selectedMessages.contains(messages[index].id)
                                ? selectedMessages.remove(messages[index].id)
                                : selectedMessages.add(messages[index].id);
                          });
                        }
                      : () {
                          setState(() {
                            favoriteMessages.contains(messages[index].id)
                                ? favoriteMessages.remove(messages[index].id)
                                : favoriteMessages.add(messages[index].id);
                          });
                        },
            ),
          );
        },
      ),
      bottomSheet: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (fileImage != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildFileImage(),
                IconButton(
                    onPressed: () {
                      setState(() {
                        fileImage = null;
                      });
                    },
                    icon: const Icon(Icons.highlight_remove))
              ],
            ),
          isEditing
              ? Row(
                  children: <Widget>[
                    buildImageButton(),
                    Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter text',
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () => setState(() {
                              messages
                                  .firstWhere((element) =>
                                      selectedMessages[0] == element.id)
                                  .text = textController.text;
                              textController.clear();
                              messages
                                  .firstWhere((element) =>
                                      selectedMessages[0] == element.id)
                                  .photo = fileImage;
                              fileImage = null;
                              isEditing = false;
                              selectedMessages.clear();
                            }),
                        icon: const Icon(Icons.edit)),
                  ],
                )
              : Row(
                  children: <Widget>[
                    buildImageButton(),
                    Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter text',
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () => setState(() {
                              messages.add(Message(id++, textController.text));
                              textController.clear();
                              if (fileImage != null) {
                                messages[messages.length - 1].photo = fileImage;
                              }
                              fileImage = null;
                              listScrollController.animateTo(
                                  listScrollController.position.maxScrollExtent,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOut);
                            }),
                        icon: const Icon(Icons.send)),
                  ],
                ),
        ],
      ),
    );
  }

  Widget buildFileImage() => Image.file(
        fileImage!,
        height: 150,
        fit: BoxFit.cover,
      );

  Widget buildImageButton() => IconButton(
        icon: const Icon(Icons.photo),
        onPressed: () async {
          final picker = ImagePicker();
          final pickedFile =
              await picker.pickImage(source: ImageSource.gallery);

          if (pickedFile == null) return;

          final file = File(pickedFile.path);

          setState(() {
            fileImage = file;
          });
        },
      );
}
