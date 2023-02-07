import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/post.dart';
import '../../repository/firebase_auth_repository.dart';
import '../../repository/firebase_repository.dart';

part 'home_cubit.dart';

class HomeState {
  final List<Post> postList;
  final int index;

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
