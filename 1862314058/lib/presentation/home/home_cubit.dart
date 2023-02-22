part of 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final _firebaseRepository = FirebaseRepository();

  HomeCubit() : super(HomeState());

  void init() async {
    _getAllPosts();
  }

  void _getAllPosts() async {
    final posts = await _firebaseRepository.getAllPosts();
    emit(state.copyWith(postList: posts));
  }

  void addPost(String titlePost) async {
    final newPost = Post(
      id: Uuid().v4(),
      title: titlePost,
      createPostTime: DateTime.now().toString(),
    );
    _firebaseRepository.addPost(newPost);
    emit(
      state.copyWith(
        postList: state.postList,
      ),
    );
    _getAllPosts();
  }

  void editPost(String postText, int index) {
    final editedPost = state.postList[index].copyWith(
      title: postText,
    );
    _firebaseRepository.editPost(editedPost);
    emit(
      state.copyWith(
        postList: state.postList,
      ),
    );
    _getAllPosts();
  }

  void deletePost(int index) {
    _firebaseRepository.deletePost(state.postList[index]);
    emit(
      state.copyWith(
        postList: state.postList,
      ),
    );
    _getAllPosts();
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
    emit(
      state.copyWith(
        postList: listP,
      ),
    );
  }
}
