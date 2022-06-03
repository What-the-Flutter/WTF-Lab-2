import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../category_page/category_cubit.dart';
import '../utils/theme/theme_cubit.dart';
import 'filters_cubit.dart';
import 'filters_state.dart';

class FiltersPage extends StatefulWidget {
  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FiltersPageCubit>().init();
    _controller.text = context.read<FiltersPageCubit>().state.parameters.searchText;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltersPageCubit, FiltersPageState>(
      builder: (blocContext, state) {
        return AnimatedContainer(
          duration: const Duration(seconds: 1),
          child: Scaffold(
            appBar: _appBar(),
            floatingActionButton: _floatingActionButton(),
            body: Column(
              children: [
                _textField(),
                _filters(state),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Filters'),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pop(context);
        context.read<FiltersPageCubit>().setSearchText(_controller.text);
        context
            .read<CategoryCubit>()
            .applyFilters(context.read<FiltersPageCubit>().state.parameters);
        _controller.clear();
      },
      child: const Icon(
        Icons.check,
      ),
    );
  }

  Widget _textField() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Container(
          height: 50,
          color: Theme.of(context).colorScheme.onPrimary,
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Color(0xFFE5E0EF),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filters(FiltersPageState state) {
    return Expanded(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            automaticallyImplyLeading: false,
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Pages',
                ),
                Tab(
                  text: 'Tags',
                ),
                Tab(
                  text: 'Labels',
                ),
                Tab(
                  text: 'Others',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _pagesFilter(state),
              _tagsFilter(state),
              _labelsFilter(state),
              _othersFilter(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pagesFilter(FiltersPageState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 80,
                color: Theme.of(context).colorScheme.onPrimary,
                child: Text(
                  context.read<FiltersPageCubit>().pagesInfo(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          _pages(state),
        ],
      ),
    );
  }

  Widget _pages(FiltersPageState state) {
    return Wrap(
      spacing: 10,
      children: [
        for (var i = 0; i < state.eventPages.length; i++)
          Container(
            width: 120,
            margin: const EdgeInsets.only(top: 5),
            child: ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                    (context.read<FiltersPageCubit>().isPageSelected(state.eventPages[i]))
                        ? context.read<ThemeCubit>().state.colorScheme.primary
                        : Colors.black12),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              onPressed: () => context.read<FiltersPageCubit>().onPagePressed(
                    state.eventPages[i],
                  ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: state.eventPages[i].icon,
                  ),
                  Text(
                    state.eventPages[i].title,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _tagsFilter(FiltersPageState state) {
    return const Placeholder();
  }

  Widget _labelsFilter(FiltersPageState state) {
    return const Placeholder();
  }

  Widget _othersFilter(FiltersPageState state) {
    return const Placeholder();
  }
}
