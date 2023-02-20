part of 'chat_cubit.dart';

class ChatState {
  final List<Message> messages;
  final PicturePath? picturePath;
  final Filter filter;

  ChatState({
    required this.messages,
    required this.filter,
    this.picturePath,
  });

  ChatState copyWith({
    List<Message>? messages,
    Filter? filter,
    PicturePath? picturePath,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      filter: filter ?? this.filter,
      picturePath: picturePath ?? this.picturePath,
    );
  }

  @override
  String toString() {
    return messages.toString();
  }
}

class PicturePath extends Equatable {
  final String? picturePath;

  PicturePath(this.picturePath);

  @override
  List<Object?> get props => [picturePath];
}

class Filter extends Equatable {
  final bool isFiltered;
  final String filterStr;
  final bool isBookmarkFilterOn;
  final List<String> hashTagFilters;

  Filter({
    required this.isFiltered,
    required this.filterStr,
    required this.isBookmarkFilterOn,
    required this.hashTagFilters,
  });

  Filter copyWith({
    bool? isFiltered,
    String? filterStr,
    bool? isBookmarkFilterOn,
    List<String>? hashTagFilters,
  }) {
    return Filter(
      isFiltered: isFiltered ?? this.isFiltered,
      filterStr: filterStr ?? this.filterStr,
      isBookmarkFilterOn: isBookmarkFilterOn ?? this.isBookmarkFilterOn,
      hashTagFilters: hashTagFilters ?? this.hashTagFilters,
    );
  }

  @override
  List<Object?> get props => [
        isFiltered,
        filterStr,
        isBookmarkFilterOn,
        hashTagFilters,
      ];
}
