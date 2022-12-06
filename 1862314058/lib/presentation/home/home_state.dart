import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/post.dart';
import '../../data/provider_db.dart';

part 'home_cubit.dart';

class HomeState {
  final List<Post> postList;
  int? index;

  HomeState({
    this.postList = const [],
    this.index = 0,
  });

  HomeState copyWith({
    List<Post>? postList,
    int? index,
  }) {
    return HomeState(
      postList: postList ?? this.postList,
      index: index ?? this.index,
    );
  }
}
