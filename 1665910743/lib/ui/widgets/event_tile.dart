import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final bool favorite;
  final File? image;
  EventTile({
    Key? key,
    required this.title,
    required this.date,
    required this.favorite,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _formattedDate = DateFormat.yMMMMd().format(date).toString();
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor),
      alignment: Alignment.centerLeft,
      child: (image != null)
          ? TileWithImage(
              image: image,
              title: title,
              formattedDate: _formattedDate,
              favorite: favorite)
          : TIleWithoutImage(
              title: title,
              formattedDate: _formattedDate,
              favorite: favorite,
            ),
    );
  }
}

class TIleWithoutImage extends StatelessWidget {
  const TIleWithoutImage({
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
          children: [
            Text(_formattedDate),
            favorite
                ? const Icon(
                    Icons.star,
                    size: 15,
                  )
                : const Icon(
                    Icons.star_border,
                    size: 15,
                  ),
          ],
        ),
      ],
    );
  }
}

class TileWithImage extends StatelessWidget {
  const TileWithImage({
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
            Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
            Row(
              children: [
                Text(_formattedDate),
                favorite
                    ? const Icon(
                        Icons.star,
                        size: 15,
                      )
                    : const Icon(
                        Icons.star_border,
                        size: 15,
                      ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
