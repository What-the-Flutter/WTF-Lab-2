part of 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  void init() async {
    emit(state.copyWith(postList: await DBProvider.instance.getAllPosts()));
  }

  void addPost(Post post) async {
    final newPost = await DBProvider.instance.addPost(post);
    final listP = state.postList;
    listP.add(newPost);
    emit(state.copyWith(postList: listP));
  }

  void editPost(Post postItem, int index) {
    final listP = state.postList;
    DBProvider.instance.editPost(listP[index]);
    listP[index] = postItem;
    emit(state.copyWith(postList: listP));
  }

  void deletePost(int index) {
    final listP = state.postList;

    DBProvider.instance.deletePost(listP[index]);
    listP.removeAt(index);
    emit(state.copyWith(postList: listP));
  }

  void pinPost(Post postItem, int index) {
    final listP = state.postList;
    if (index == 0) {
      listP.insert(3, listP[index]);
      listP.removeAt(0);
    } else {
      listP.insert(0, listP[index]);
      listP.removeAt(index + 1);
    }
    emit(state.copyWith(postList: listP));
  }
}
