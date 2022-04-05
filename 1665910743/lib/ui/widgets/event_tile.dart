import 'package:flutter/material.dart';

import '../../extensions/date_extension.dart';

class EventTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final bool favorite;
  final Image? image;
  final bool isSelected;
  final int iconCode;

  EventTile({
    Key? key,
    required this.title,
    required this.date,
    required this.favorite,
    required this.isSelected,
    required this.iconCode,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black38
                  : Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: const Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.7)
              : Theme.of(context).primaryColor),
      child: (image != null)
          ? _TileWithImage(
              image: image,
              title: title,
              formattedDate: date.mmddyy(),
              favorite: favorite,
            )
          : _TileWithoutImage(
              title: title,
              formattedDate: date.mmddyy(),
              favorite: favorite,
              iconCode: iconCode),
    );
  }
}

class _TileWithoutImage extends StatelessWidget {
  final String title;
  final String _formattedDate;
  final bool favorite;
  final int iconCode;
  const _TileWithoutImage({
    Key? key,
    required this.title,
    required String formattedDate,
    required this.favorite,
    required this.iconCode,
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
            Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formattedDate,
                  style: const TextStyle(fontSize: 10),
                ),
                Icon(
                  favorite ? Icons.star : Icons.star_border,
                  size: 10,
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

  _TileWithImage({
    Key? key,
    required this.image,
    required this.title,
    required this.favorite,
    required this.formattedDate,
  }) : super(key: key);

  @override
  State<_TileWithImage> createState() => _TileWithImageState();
}

class _TileWithImageState extends State<_TileWithImage> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 20, overflow: TextOverflow.fade),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.formattedDate,
                  style: const TextStyle(fontSize: 10),
                ),
                Icon(
                  widget.favorite ? Icons.star : Icons.star_border,
                  size: 10,
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}
