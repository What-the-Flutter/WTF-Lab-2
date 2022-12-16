import 'package:flutter/cupertino.dart';
import 'message.dart';

class PostFields {
  static final values = [id, title, createPostTime];
  static const String id = '_id';
  static const String title = 'title';

  //static const String icon = 'icon';
  static const String createPostTime = 'createPostTime';
}

class Post {
  final int id;
  final String title;

  //final IconData icon;
  final String createPostTime;

  //final List<Message> messages = [];

  Post({
    required this.title,
    required this.createPostTime,
    //required this.icon,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        PostFields.id: id,
        PostFields.title: title,
        //PostFields.icon: icon,
        PostFields.createPostTime: createPostTime
      };

  static Post fromJson(Map<String, dynamic> json) => Post(
        id: json[PostFields.id] as int,
        title: json[PostFields.title] as String,
        //icon: json[PostFields.icon] as Icon,
        createPostTime: json[PostFields.createPostTime] as String,
      );

  Post copyWith({int? id, String? title, String? createPostTime}) => Post(
        id: id ?? this.id,
        title: title ?? this.title,
        //icon: icon ?? this.icon,
        createPostTime: createPostTime ?? this.createPostTime,
      );
}
