part of 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  final List<Post> _postList = [Post(title: 'Journal'), Post(title: 'Travel')];

  void init() => emit(state.copyWith(postList: _postList));

  void addPost(Post post) {
    state.postList.add(post);
    emit(state.copyWith(postList: state.postList));
  }

  void editPost(Post postItem, int index) {
    state.postList[index] = postItem;
    emit(state.copyWith(postList: state.postList));
  }

  void deletePost(int index) {
    state.postList.removeAt(index);
    emit(state.copyWith(postList: state.postList));
  }

  void pinPost(Post postItem, int index) {
    if (index == 0) {
      state.postList.insert(3, state.postList[index]);
      state.postList.removeAt(0);
    } else {
      state.postList.insert(0, state.postList[index]);
      state.postList.removeAt(index + 1);
    }
    emit(state.copyWith(postList: state.postList));
  }
}
