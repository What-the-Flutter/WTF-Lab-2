class PostFields {
  static final values = [
    id,
    title,
    createPostTime,
  ];
  static const String id = '_id';
  static const String title = 'title';
  static const String createPostTime = 'createPostTime';
}

class Post {
  final String id;
  final String title;
  final String createPostTime;

  Post({
    required this.title,
    required this.createPostTime,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        PostFields.id: id,
        PostFields.title: title,
        PostFields.createPostTime: createPostTime
      };

  static Post fromJson(Map<String, dynamic> json) => Post(
        id: json[PostFields.id] as String,
        title: json[PostFields.title] as String,
        createPostTime: json[PostFields.createPostTime] as String,
      );

  Post copyWith({String? id, String? title, String? createPostTime}) => Post(
        id: id ?? this.id,
        title: title ?? this.title,
        createPostTime: createPostTime ?? this.createPostTime,
      );
}
