import 'package:flutter/material.dart';

import '../../../entities/event.dart';

class FavoriteButton extends StatefulWidget {
  final Event event;
  const FavoriteButton({Key? key, required this.event}) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          widget.event.isFavorite = !widget.event.isFavorite;
        });
      },
      icon: widget.event.isFavorite
          ? const Icon(Icons.favorite)
          : const Icon(Icons.favorite_border_outlined),
    );
  }
}
