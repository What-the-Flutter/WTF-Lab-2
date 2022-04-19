import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/icons_pack.dart';
import 'cubit/event_cubit.dart';

class IconsGrid extends StatelessWidget {
  const IconsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: kIcons.length,
              itemBuilder: ((context, index) => GestureDetector(
                    onTap: (() {
                      context.read<EventCubit>().iconSelect(index);
                      context
                          .read<EventCubit>()
                          .iconAdd(context.read<EventCubit>().state.iconAdd);
                    }),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        radius: 20,
                        child: kIcons[index],
                      ),
                    ),
                  )),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<EventCubit>().iconSelect(-1);
              context
                  .read<EventCubit>()
                  .iconAdd(context.read<EventCubit>().state.iconAdd);
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                radius: 20,
                child: const Icon(Icons.cancel_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
