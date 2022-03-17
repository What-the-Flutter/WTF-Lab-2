import 'dart:io';

import 'package:flutter/material.dart';

import '../../extensions/date_extension.dart';

class EventTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final bool favorite;
  final File? image;
  final bool isSelected;

  EventTile({
    Key? key,
    required this.title,
    required this.date,
    required this.favorite,
    this.image,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
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
              favorite: favorite)
          : _TileWithoutImage(
              title: title,
              formattedDate: date.mmddyy(),
              favorite: favorite,
            ),
    );
  }
}

class _TileWithoutImage extends StatelessWidget {
  const _TileWithoutImage({
    Key? key,
    required this.title,
    required String formattedDate,
    required this.favorite,
  })  : _formattedDate = formattedDate,
        super(key: key);

  final String title;
  final String _formattedDate;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            favorite
                ? const Icon(
                    Icons.star,
                    size: 10,
                  )
                : const Icon(
                    Icons.star_border,
                    size: 10,
                  ),
          ],
        ),
      ],
    );
  }
}

class _TileWithImage extends StatelessWidget {
  const _TileWithImage({
    Key? key,
    required this.image,
    required this.title,
    required String formattedDate,
    required this.favorite,
  })  : _formattedDate = formattedDate,
        super(key: key);

  final File? image;
  final String title;
  final String _formattedDate;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.file(
          image!,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 20, overflow: TextOverflow.fade),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formattedDate,
                  style: const TextStyle(fontSize: 10),
                ),
                favorite
                    ? const Icon(
                        Icons.star,
                        size: 10,
                      )
                    : const Icon(
                        Icons.star_border,
                        size: 10,
                      ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
