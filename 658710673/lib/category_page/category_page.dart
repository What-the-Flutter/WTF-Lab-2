import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../home_page/home_cubit.dart';
import '../models/category.dart';
import '../models/event.dart';
import '../models/section.dart';
import '../settings_page/settings_cubit.dart';
import '../utils/constants.dart';
import '../utils/theme/theme_cubit.dart';
import 'category_cubit.dart';
import 'category_state.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  const CategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryCubit>(context).init(widget.category);
  }

  @override
  Widget build(BuildContext ctx) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: state.events.where((element) => element.isSelected == true).isEmpty &&
                  !state.isEditingMode
              ? state.isSearchMode
                  ? _searchAppBar()
                  : _appBar(state)
              : state.isMessageEdit
                  ? _messageEditBar(state)
                  : _editAppBar(context, state),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: context.read<SettingsCubit>().isBackgroundSet()
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: Image.file(
                                    File(context.read<SettingsCubit>().state.backgroundImagePath))
                                .image,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const BoxDecoration(),
                  child: state.events.isEmpty ? _bodyWithoutEvents() : _bodyWithEvents(state, ctx),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: state.isSearchMode ? Container() : _inputTextField(state),
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _appBar(CategoryState state) {
    return AppBar(
      title: Center(
        child: Text(
          widget.category.title,
          style: TextStyle(
            fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => BlocProvider.of<CategoryCubit>(context).changeSearchMode(),
        ),
        IconButton(
          icon:
              state.isFavoriteMode ? const Icon(Icons.bookmark) : const Icon(Icons.bookmark_border),
          onPressed: () => BlocProvider.of<CategoryCubit>(context).changeFavoriteMode(),
        ),
      ],
    );
  }

  AppBar _searchAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => BlocProvider.of<CategoryCubit>(context).changeSearchMode(),
      ),
      title: Center(
        child: TextField(
          style: TextStyle(
            fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
          ),
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
          ),
          showCursor: true,
          onChanged: (value) => BlocProvider.of<CategoryCubit>(context).search(value),
        ),
      ),
    );
  }

  AppBar _messageEditBar(CategoryState state) {
    return AppBar(
      title: Center(
        child: Text(
          'Edit mode',
          style: TextStyle(
            fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            BlocProvider.of<CategoryCubit>(context).changeMessageEditMode();
            BlocProvider.of<CategoryCubit>(context).changeEditingMode();
          },
        ),
      ],
    );
  }

  AppBar _editAppBar(BuildContext context, CategoryState state) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          BlocProvider.of<CategoryCubit>(context).cancelSelectedEvents();
        },
      ),
      title: Center(
        child: Text(
          state.events.where((element) => element.isSelected == true).length.toString(),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _replyEvents(context, state);
          },
          icon: const Icon(Icons.reply),
        ),
        if (state.events.where((element) => element.isSelected == true).length == 1 &&
            !state.isAttachment)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                _textController.text = BlocProvider.of<CategoryCubit>(context).editEvent(),
          ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () => BlocProvider.of<CategoryCubit>(context).copyToClipboard(),
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: () => BlocProvider.of<CategoryCubit>(context).changeEventBookmark(),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _dialog(context),
        ),
      ],
    );
  }

  Container _bodyWithoutEvents() {
    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      width: 400,
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'This is the page where you can track everything about '
            '"${widget.category.title}"!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            'Add your first event to "${widget.category.title}" page by entering some'
            'text in the text box below and hitting the send button. Long tap '
            'the send button to align the event in the opposite direction. Tap '
            'on the bookmark icon on the top right corner to show the '
            'bookmarked events only.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  ListView _bodyWithEvents(CategoryState state, BuildContext ctx) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: state.isSearchMode ? state.searchedEvents.length : state.events.length,
      itemBuilder: (context, index) => Column(
        children: [
          index == 0 ||
                  DateFormat.yMMMMd().format(state.events[index].timeOfCreation) !=
                      DateFormat.yMMMMd().format(state.events[index - 1].timeOfCreation)
              ? Align(
                  alignment: BlocProvider.of<SettingsCubit>(context).state.isDateCenterAlign
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: Container(
                    width: 140,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.read<ThemeCubit>().state.colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      DateFormat.yMMMMd().format(state.events[index].timeOfCreation).toString(),
                      style: TextStyle(
                        fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          Dismissible(
            key: Key(state.events[index].toString()),
            child: Align(
              alignment: BlocProvider.of<SettingsCubit>(context).state.isBubbleChatLeft
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: GestureDetector(
                onTap: () =>
                    BlocProvider.of<CategoryCubit>(context).tapOnEvent(index, _textController),
                onLongPress: () => BlocProvider.of<CategoryCubit>(context).selectEvent(index),
                child: state.isSearchMode
                    ? _eventMessage(index, state, state.searchedEvents)
                    : _eventMessage(index, state, state.events),
              ),
            ),
            background: Container(
              color: context.read<ThemeCubit>().state.colorScheme.primary,
              alignment: Alignment.centerLeft,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: context.read<ThemeCubit>().state.colorScheme.primary,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              color: context.read<ThemeCubit>().state.colorScheme.primary,
              alignment: Alignment.centerRight,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: context.read<ThemeCubit>().state.colorScheme.primary,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                BlocProvider.of<CategoryCubit>(context).selectEvent(index);
                _textController.text = BlocProvider.of<CategoryCubit>(context).editEvent();
              } else {
                BlocProvider.of<CategoryCubit>(context).selectEvent(index);
                BlocProvider.of<CategoryCubit>(context).deleteEvent();
              }
            },
          ),
        ],
      ),
    );
  }

  Container _eventMessage(int index, CategoryState state, List<Event> events) {
    if (state.isFavoriteMode) {
      if (!events[index].isBookmarked) {
        return Container();
      }
    }
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: events[index].isSelected
            ? context.read<ThemeCubit>().state.colorScheme.primary
            : context.read<ThemeCubit>().state.highlightColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          state.events[index].sectionTitle !=
                      BlocProvider.of<CategoryCubit>(context).defaultSection.title &&
                  events[index].attachment == null
              ? Wrap(
                  children: [
                    Icon(IconData(
                        BlocProvider.of<CategoryCubit>(context).state.events[index].sectionIcon!)),
                    Text(BlocProvider.of<CategoryCubit>(context).state.events[index].sectionTitle),
                  ],
                )
              : Wrap(),
          Text(
            events[index].description.toString(),
            style: TextStyle(
              fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
            ),
          ),
          if (events[index].attachment != null)
            ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 5.0,
                minWidth: 5.0,
                maxHeight: 200.0,
                maxWidth: 200.0,
              ),
              child: Image.file(File(events[index].attachment!)),
            ),
          Wrap(
            children: [
              if (events[index].isSelected) const Icon(Icons.done, size: 12),
              Text(
                DateFormat().add_jm().format(events[index].timeOfCreation).toString(),
                style: TextStyle(
                  fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (events[index].isBookmarked) const Icon(Icons.bookmark, size: 12),
            ],
          )
        ],
      ),
    );
  }

  Container _inputTextField(CategoryState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _showSectionList(state),
            icon: Icon(
              state.selectedSection!.iconData,
            ),
          ),
          Expanded(
            child: TextField(
              style: TextStyle(
                fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
              ),
              onChanged: (text) => BlocProvider.of<CategoryCubit>(context).changeWritingMode(text),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Enter event',
                filled: true,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              controller: _textController,
            ),
          ),
          state.isWritingMode
              ? IconButton(
                  onPressed: () {
                    BlocProvider.of<CategoryCubit>(context)
                        .addNewEvent(_textController.text, widget.category);
                    _textController.text = '';
                  },
                  icon: const Icon(Icons.send),
                )
              : IconButton(
                  onPressed: () =>
                      BlocProvider.of<CategoryCubit>(context).attachImage(widget.category),
                  icon: const Icon(Icons.image),
                ),
        ],
      ),
    );
  }

  Future<dynamic> _showSectionList(CategoryState state) {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return Container(
          height: 70,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: _sectionsList(state),
        );
      },
    );
  }

  Widget _sectionsList(CategoryState state) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: sections.length,
      itemBuilder: (context, index) {
        return _sectionItem(state, index);
      },
    );
  }

  Widget _sectionItem(CategoryState state, int index) {
    var section = Section(
      title: sections.keys.elementAt(index),
      iconData: sections.values.elementAt(index),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          IconButton(
            icon: Icon(
              section.iconData,
              size: 32,
            ),
            onPressed: () {
              BlocProvider.of<CategoryCubit>(context).setSection(section);
              Navigator.pop(context);
            },
          ),
          Text(
            section.title,
            style: TextStyle(
              fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
            ),
          ),
        ],
      ),
    );
  }

  void _dialog(BuildContext ctx) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Do you want to delete events?',
          style: TextStyle(
            fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              BlocProvider.of<CategoryCubit>(ctx).deleteEvent();
              Navigator.pop(context);
            },
            child: Text(
              'Yes',
              style: TextStyle(
                fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: TextStyle(
                fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _replyEvents(BuildContext ctx, CategoryState state) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Text(
                  'Select the page you want '
                  'to migrate the selected '
                  'event(s) to!',
                  style: TextStyle(
                    fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                width: 300,
                child: _replyEventListView(ctx, state),
              ),
              _replyDialogButtons(state),
            ],
          ),
        );
      },
    );
  }

  ListView _replyEventListView(BuildContext ctx, CategoryState state) {
    return ListView.builder(
      itemCount: context.read<HomeCubit>().state.categories.length,
      itemBuilder: (context, index) {
        return RadioListTile<int>(
          title: Text(
            ctx.read<HomeCubit>().state.categories[index].title,
            style: TextStyle(
              fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
            ),
          ),
          activeColor: Theme.of(context).primaryColor,
          value: index,
          groupValue: state.replyCategoryIndex,
          onChanged: (value) {
            ctx.read<CategoryCubit>().setReplyCategory(ctx, value as int);
          },
        );
      },
    );
  }

  Widget _replyDialogButtons(CategoryState state) {
    return Row(
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<CategoryCubit>(context).replyEvents(context);
            Navigator.pop(context);
          },
          child: Text(
            'Move',
            style: TextStyle(
              fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
            ),
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
