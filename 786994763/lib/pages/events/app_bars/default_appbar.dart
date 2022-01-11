import 'package:flutter/material.dart';

import '../../../styles.dart';
import '../add_event_route.dart';
import '../const_widgets.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function() backButtonClick;
  final Function() showFavourites;
  final bool isFavouritesOn;
  const DefaultAppBar({
    Key? key,
    required this.backButtonClick,
    required this.showFavourites,
    required this.isFavouritesOn,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff7289da),
      centerTitle: true,
      title: Text(
        EventList.title,
        style: titlePageStyle,
      ),
      leading: IconButton(
        icon: iconArrowBack,
        onPressed: backButtonClick,
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: iconSearch,
        ),
        IconButton(
          onPressed: showFavourites,
          icon: isFavouritesOn ? favouriteIcon : favouriteIconOutlined,
        ),
      ],
    );
  }
}
