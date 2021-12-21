import 'package:flutter/material.dart';

Widget get eventEdited {
  return Container(
    height: 34,
    child: const Icon(Icons.edit, size: 18),
    padding: const EdgeInsets.only(left: 4),
  );
}

Widget get eventFavourite {
  return Container(
    height: 34,
    child: const Icon(
      Icons.favorite_rounded,
      size: 18,
      color: Color(0xffFC0A54),
    ),
    padding: const EdgeInsets.only(left: 6),
  );
}

Widget get emptyContainer {
  return Container(
    height: 34,
  );
}

Widget get favouriteIcon {
  return const Icon(
    Icons.favorite_rounded,
    color: Color(0xffFC0A54),
  );
}

Widget get favouriteIconOutlined {
  return const Icon(
    Icons.favorite_outline,
  );
}

Widget get iconCancel {
  return const Icon(
    Icons.cancel,
  );
}

Widget get iconBubbleChart {
  return const Icon(
    Icons.bubble_chart,
  );
}

Widget get iconSendEvent {
  return const Icon(
    Icons.send,
  );
}

Widget get iconSearch {
  return const Icon(
    Icons.search,
  );
}

Widget get iconEdit {
  return const Icon(
    Icons.edit,
  );
}

Widget get iconCopy {
  return const Icon(
    Icons.copy,
  );
}

Widget get iconDelete {
  return const Icon(
    Icons.delete,
  );
}

Widget get iconCheck {
  return const Icon(
    Icons.check,
    size: 28,
  );
}

Widget get iconArrowBack {
  return const Icon(
    Icons.arrow_back,
  );
}
