import 'package:flutter/material.dart';

import '../../../styles.dart';
import '../add_event_route.dart';
import '../const_widgets.dart';

class DefaultAppBar extends StatelessWidget {
  final Function backButton;
  final Function showFavourites;
  final bool isFavouritesOn;
  const DefaultAppBar({
    Key? key,
    required this.backButton,
    required this.showFavourites,
    required this.isFavouritesOn,
  }) : super(key: key);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigo,
      centerTitle: true,
      title: Text(
        EventList.title,
        style: titlePageStyle,
      ),
      leading: IconButton(
        icon: iconArrowBack,
        onPressed: backButton(),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: iconSearch,
        ),
        IconButton(
          onPressed: showFavourites(),
          icon: isFavouritesOn ? favouriteIcon : favouriteIconOutlined,
        ),
      ],
    );
  }
}
