import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

class Constants {
  static const lSecondaryColor = Color(0xFFedf0f7);
  static const lPrimaryColor = Color(0xFF747DF2);
  static const lIconColor = Colors.black;

  static const dSecondaryColor = Color(0xFF172f3c);
  static const dPrimaryColor = Color(0xFF5f9095);
  static const dIconColor = Colors.white;
}

class FontSizes {
  static const fontSizes = <FontSizeKeys, double>{
    FontSizeKeys.small: 12.0,
    FontSizeKeys.medium: 16.0,
    FontSizeKeys.large: 20.0,
  };
}

class CategoryIcons {
  static const List<Icon> icons = [
    Icon(Icons.flight_takeoff),
    Icon(Icons.family_restroom),
    Icon(Icons.sports_volleyball),
    Icon(Icons.grade),
    Icon(Icons.sports_bar),
    Icon(Icons.sports_basketball),
    Icon(Icons.add),
    Icon(Icons.radar),
    Icon(Icons.sailing),
    Icon(Icons.earbuds),
    Icon(Icons.videogame_asset),
    Icon(Icons.enhance_photo_translate),
    Icon(Icons.access_alarm),
    Icon(Icons.account_balance_sharp),
    Icon(Icons.add_ic_call),
    Icon(Icons.add_shopping_cart_sharp),
    Icon(Icons.agriculture_sharp),
    Icon(Icons.anchor_sharp),
    Icon(Icons.vpn_key_sharp),
    Icon(Icons.wine_bar),
    Icon(Icons.work_rounded),
    Icon(Icons.weekend),
    Icon(Icons.wifi_protected_setup),
    Icon(Icons.airline_seat_individual_suite),
    Icon(Icons.visibility),
    Icon(Icons.volunteer_activism),
    Icon(Icons.apartment),
    Icon(Icons.voice_chat),
    Icon(Icons.watch),
    Icon(Icons.wash),
  ];
}

const Map<String, IconData> sections = {
  'Food': Icons.fastfood,
  'Running': Icons.directions_run,
  'Laundry': Icons.local_laundry_service,
  'Sport': Icons.sports_basketball,
  'Shopping': Icons.shopping_cart,
  'Movie': Icons.movie,
  'Fav': Icons.star,
};
