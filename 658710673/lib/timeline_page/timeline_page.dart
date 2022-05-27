import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../category_page/category_cubit.dart';
import '../category_page/category_state.dart';
import '../filters_page/filters_cubit.dart';
import '../filters_page/filters_page.dart';
import '../home_page/home_cubit.dart';
import '../models/category.dart';
import '../models/event.dart';
import '../settings_page/settings_cubit.dart';
import '../utils/theme/theme_cubit.dart';
import '../widgets/main_page_widgets/main_bottom_bar.dart';
import '../widgets/main_page_widgets/main_drawer.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
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
    BlocProvider.of<CategoryCubit>(context).initTimeline();
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
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _openFiltersPage,
            child: const Icon(Icons.filter_list),
          ),
          bottomNavigationBar: MainBottomBar(),
          drawer: const MainDrawer(),
        );
      },
    );
  }

  AppBar _appBar(CategoryState state) {
    return AppBar(
      title: Center(
        child: Text(
          'Timeline',
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
          onPressed: () => _showDialog(context),
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
            'Your timeline is empty! ',
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
            'There are no events to be displayed on your timeline, or you have filtered out all your'
            ' pages in the filter menu',
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

  Widget _bodyWithEvents(CategoryState state, BuildContext ctx) {
    if (state.filteredEvents.isEmpty) {
      return Lottie.network(
        'https://assets7.lottiefiles.com/packages/lf20_fmieo0wt.json',
        repeat: true,
        reverse: true,
        animate: true,
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: state.isSearchMode ? state.searchedEvents.length : state.filteredEvents.length,
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
                      : _eventMessage(index, state, state.filteredEvents),
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
  }

  Widget _eventMessage(int index, CategoryState state, List<Event> events) {
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
            context
                .read<HomeCubit>()
                .state
                .categories
                .where((element) => element.id == events[index].category)
                .toString(),
            style: TextStyle(
              fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
              fontStyle: FontStyle.italic,
            ),
          ),
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

  void _showDialog(BuildContext ctx) {
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

  void _openFiltersPage() async {
    final category = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<FiltersPageCubit>(context),
            ),
            BlocProvider.value(
              value: BlocProvider.of<ThemeCubit>(context),
            ),
            BlocProvider.value(
              value: BlocProvider.of<SettingsCubit>(context),
            ),
            BlocProvider.value(
              value: BlocProvider.of<HomeCubit>(context),
            ),
            BlocProvider.value(
              value: BlocProvider.of<CategoryCubit>(context),
            ),
          ],
          child: FiltersPage(),
        ),
      ),
    );
    if (category is Category && mounted) {
      BlocProvider.of<HomeCubit>(context).addCategory(category);
    }
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
