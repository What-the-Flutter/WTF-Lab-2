import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../category_screen/cubit/category_cubit.dart';
import '../chat_screen/cubit/event_cubit.dart';

Future<void> filterDialog(BuildContext context) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.white.withOpacity(0.0),
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.95,
    ),
    context: context,
    builder: (buildContext) {
      return SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BlocProvider.value(
            value: context.read<CategoryCubit>(),
            child: const FilterBody()),
        ),
      );
    },
  );
}

class FilterBody extends StatelessWidget {
  const FilterBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(maxHeight: _screenSize.height * 0.95),
      margin: EdgeInsets.only(top: _screenSize.height * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      height: _screenSize.height * 0.75,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(25)),
              child: Text(
                'Show Events From caterory:',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 40,
              thickness: 3,
              indent: 100,
              endIndent: 100,
            ),
            Expanded(
              child: BlocBuilder<CategoryCubit, CategoryState>(
                bloc: context.read<CategoryCubit>(),
                builder: ((context, state) {
                  return ListView.builder(
                    itemBuilder: ((context, index) {
                      return const ListTile();
                    }),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
