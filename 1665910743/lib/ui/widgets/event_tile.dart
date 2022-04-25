import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../extensions/date_extension.dart';
import '../screens/settings/cubit/settings_cubit.dart';
import '../theme/theme_data.dart';

const double _borderRadius = 15.0;

class EventTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final bool favorite;
  final bool isSelected;
  final int iconCode;
  final int tag;
  final Image? image;

  const EventTile({
    Key? key,
    required this.title,
    required this.date,
    required this.favorite,
    required this.isSelected,
    required this.iconCode,
    required this.tag,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: context.read<SettingsCubit>(),
      builder: ((context, state) {
        final _tileAlignLeft = state.chatTileAlignment == Alignment.centerLeft;

        return AnimatedScale(
          scale: isSelected ? 1.1 : 1,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(_borderRadius),
                  topRight: const Radius.circular(_borderRadius),
                  bottomRight: _tileAlignLeft
                      ? const Radius.circular(_borderRadius)
                      : const Radius.circular(0),
                  bottomLeft: _tileAlignLeft
                      ? const Radius.circular(0)
                      : const Radius.circular(_borderRadius),
                ),
                color: isSelected
                    ? MyThemes.selectedColor
                    : Theme.of(context).primaryColor),
            child: (image != null)
                ? _TileWithImage(
                    image: image,
                    title: title,
                    formattedDate: date.mmdd(),
                    favorite: favorite,
                    iconCode: iconCode,
                    tag: tag,
                  )
                : _TileWithoutImage(
                    title: title,
                    formattedDate: date.mmdd(),
                    favorite: favorite,
                    iconCode: iconCode,
                    tag: tag,
                  ),
          ),
        );
      }),
    );
  }
}

class _TileWithoutImage extends StatelessWidget {
  final String title;
  final String _formattedDate;
  final bool favorite;
  final int iconCode;
  final int tag;

  const _TileWithoutImage({
    Key? key,
    required this.title,
    required String formattedDate,
    required this.favorite,
    required this.iconCode,
    required this.tag,
  })  : _formattedDate = formattedDate,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        (iconCode != 0)
            ? Icon(
                IconData(iconCode, fontFamily: 'MaterialIcons'),
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 50,
              )
            : const SizedBox(),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.02,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5),
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.clip,
              ),
            ),
            (tag != -1)
                ? Text(
                    tagsList[tag],
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                : const SizedBox(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formattedDate,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    favorite ? Icons.bookmark : Icons.bookmark_border,
                    size: 20,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}

class _TileWithImage extends StatefulWidget {
  final Image? image;
  final String title;
  final String formattedDate;
  final bool favorite;
  final int iconCode;
  final int tag;

  _TileWithImage({
    Key? key,
    required this.image,
    required this.title,
    required this.favorite,
    required this.formattedDate,
    required this.iconCode,
    required this.tag,
  }) : super(key: key);

  @override
  State<_TileWithImage> createState() => _TileWithImageState();
}

class _TileWithImageState extends State<_TileWithImage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: widget.image),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.5),
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                (widget.tag != -1)
                    ? Text(
                        tagsList[widget.tag],
                        style: Theme.of(context).textTheme.bodyText2,
                      )
                    : const SizedBox(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.formattedDate,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Icon(
                      widget.favorite ? Icons.bookmark : Icons.bookmark_border,
                      size: 20,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    )
                  ],
                ),
              ],
            ),
            (widget.iconCode != 0)
                ? Icon(
                    IconData(widget.iconCode, fontFamily: 'MaterialIcons'),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: 50,
                  )
                : const SizedBox(),
          ],
        )
      ],
    );
  }
}
