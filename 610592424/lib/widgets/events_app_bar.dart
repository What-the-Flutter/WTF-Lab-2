import 'package:flutter/material.dart';

enum AppbarStates { normal, singleSelected, multiSelected, editing, searching }

class EventsAppBar extends StatelessWidget with PreferredSizeWidget {
  final AppbarStates _currentState;
  final String _title;

  final bool anyHashtags;
  final Future<List<String>>? hashTags;

  final Function()? onBackArrowButtonTap;
  final Function()? onSearchButtonTap;
  final Function()? onCancelButtonTap;
  final Function()? onEditingButtonTap;
  final Function()? onCopyButtonTap;
  final Function()? onDeleteButtonTap;
  final Function()? onForwardButtonTap;

  final Function(String text) applySearch;

  const EventsAppBar(
    this._currentState,
    this._title, {
    required this.applySearch,
    Key? key,
    this.onBackArrowButtonTap,
    this.onSearchButtonTap,
    this.onCancelButtonTap,
    this.onEditingButtonTap,
    this.onCopyButtonTap,
    this.onDeleteButtonTap,
    this.onForwardButtonTap,
    this.anyHashtags = false,
    this.hashTags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (_currentState) {
      case AppbarStates.normal:
        return AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: onBackArrowButtonTap,
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          title: Center(
            child: Text(_title),
          ),
          actions: [
            IconButton(
              onPressed: onSearchButtonTap,
              icon: const Icon(Icons.search_outlined),
            ),
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.bookmark_border_outlined),
            ),
          ],
        );
      case AppbarStates.editing:
        return AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: onCancelButtonTap,
            icon: const Icon(Icons.close),
          ),
          title: const Center(
            child: Text("Editing mode"),
          ),
        );
      case AppbarStates.singleSelected:
        return AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: onCancelButtonTap,
            icon: const Icon(Icons.close),
          ),
          actions: [
            IconButton(
              onPressed: onEditingButtonTap,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: onCopyButtonTap,
              icon: const Icon(Icons.content_copy_outlined),
            ),
            IconButton(
              onPressed: onForwardButtonTap,
              icon: const Icon(Icons.shortcut_outlined),
            ),
            IconButton(
              onPressed: onDeleteButtonTap,
              icon: const Icon(Icons.delete),
            ),
          ],
        );
      case AppbarStates.multiSelected:
        return AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: onCancelButtonTap,
            icon: const Icon(Icons.close),
          ),
          actions: [
            IconButton(
              onPressed: onCopyButtonTap,
              icon: const Icon(Icons.content_copy_outlined),
            ),
            IconButton(
              onPressed: onForwardButtonTap,
              icon: const Icon(Icons.shortcut_outlined),
            ),
            IconButton(
              onPressed: onDeleteButtonTap,
              icon: const Icon(Icons.delete),
            ),
          ],
        );
      case AppbarStates.searching:
        return AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: onCancelButtonTap,
            icon: const Icon(Icons.close),
          ),
          title: TextFormField(
            cursorColor: Colors.red,
            autofocus: false,
            onChanged: (text) => applySearch(text),
          ),
          bottom: _getAppbarBottom(),
        );
      default:
        throw Exception("wrong state");
    }
  }

  PreferredSizeWidget? _getAppbarBottom() {
    if (!anyHashtags) {
      return null;
    } else {
      return PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 60.0),
          child: FutureBuilder(
            future: hashTags,
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => applySearch(snapshot.data![index]),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blueGrey,
                        ),
                        child: Text(snapshot.data![index]),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      );
    }
  }

  @override
  Size get preferredSize =>
      Size.fromHeight((_currentState == AppbarStates.searching && anyHashtags)
          ? 125
          : kToolbarHeight);
}
