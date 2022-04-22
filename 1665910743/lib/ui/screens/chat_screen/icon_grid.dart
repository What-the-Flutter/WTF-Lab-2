import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'cubit/event_cubit.dart';

class IconsGrid extends StatelessWidget {
  final EventCubit eventCubit;

  const IconsGrid({Key? key, required this.eventCubit}) : super(key: key);

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
              itemCount: iconPack.length,
              itemBuilder: ((context, index) => GestureDetector(
                    onTap: (() {
                      eventCubit.iconSelect(index);
                      eventCubit.iconAdd(eventCubit.state.iconAdd);
                    }),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        radius: 20,
                        child: iconPack[index],
                      ),
                    ),
                  )),
            ),
          ),
          GestureDetector(
            onTap: () {
              eventCubit.iconSelect(-1);
              eventCubit.iconAdd(eventCubit.state.iconAdd);
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
