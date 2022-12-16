part of 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  User? user;
  late final FirebaseRepository _firebaseRepository =
      FirebaseRepository(user: user);

  HomeCubit({required this.user}) : super(HomeState());

  void init() async {
    emit(state.copyWith(postList: await _firebaseRepository.getAllPosts()));
  }

  void addPost(Post post) async {
    _firebaseRepository.addPost(post);
    final listP = state.postList;
    listP.add(post);
    emit(state.copyWith(postList: listP));
  }

  void editPost(Post postItem, int index) {
    final listP = state.postList;
    _firebaseRepository.editPost(postItem);
    listP[index] = postItem;
    emit(state.copyWith(postList: listP));
  }

  void deletePost(int index) {
    final listP = state.postList;
    _firebaseRepository.deletePost(listP[index]);
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
