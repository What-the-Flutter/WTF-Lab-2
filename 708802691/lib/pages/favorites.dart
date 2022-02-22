import 'package:flutter/material.dart';
import 'events_chats.dart';

class Favorites extends StatefulWidget {
  final Event event;

  const Favorites({Key? key, required this.event}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState(event: event);
}

class _FavoritesState extends State<Favorites> {
  Event event;
  late final favorites = favoriteNotes(event.notes);

  _FavoritesState({required this.event});

  List<Note> favoriteNotes(List<Note> allNotes) {
    var favoriteNotes = <Note>[];
    for (var note in allNotes) {
      if (note.isFavorite) favoriteNotes.add(note);
    }
    return favoriteNotes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(7),
          ),
        ),
        backgroundColor: const Color.fromRGBO(135, 148, 192, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: const Color.fromRGBO(28, 33, 53, 1),
          onPressed: () => Navigator.pop(context),
        ),
        title: Expanded(
          child: Center(
            child: Text(
              event.title,
              style: const TextStyle(
                color: Color.fromRGBO(28, 33, 53, 1),
              ),
            ),
          ),
        ),
        actions: const [
          Icon(
            Icons.star_rounded,
            color: Color.fromRGBO(216, 205, 176, 1),
          ),
        ],
      ),
      body: Column(
        children: [
          if (favorites.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: favorites.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: (favorites[index].rightHanded
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 200,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (favorites[index].rightHanded
                                ? Colors.grey.shade200
                                : Colors.blue[200]),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                favorites[index].content,
                                style: const TextStyle(fontSize: 15),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  (favorites[index].isSelected)
                                      ? const Icon(
                                          Icons.check_rounded,
                                          size: 20,
                                          color: Colors.black,
                                        )
                                      : const SizedBox(
                                          width: 0.2,
                                        ),
                                  Text(
                                    favorites[index].time,
                                    style: const TextStyle(fontSize: 11),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  (favorites[index].isFavorite)
                                      ? const Icon(
                                          Icons.star_rounded,
                                          size: 20,
                                          color: Color.fromRGBO(
                                              216, 205, 176, 0.9),
                                        )
                                      : const SizedBox(
                                          width: 0.2,
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
