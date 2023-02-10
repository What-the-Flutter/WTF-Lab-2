part of 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final _firebaseRepository = FirebaseRepository();

  HomeCubit() : super(HomeState());

  void init() async {
    _getAllPosts();
  }

  void _getAllPosts() {
    _firebaseRepository.listenPosts().listen(
      (event) {
        var posts = <Post>[];
        var data = (event.snapshot.value ?? {}) as Map;
        data.forEach((key, value) {
          posts.add(
            Post.fromJson({'id': key, ...value}),
          );
        });
        emit(
          state.copyWith(
            postList: posts,
          ),
        );
      },
    );
  }

  void addPost(Post post) async {
    _firebaseRepository.addPost(post);
    final listP = state.postList;
    listP.add(post);
    emit(
      state.copyWith(
        postList: listP,
      ),
    );
  }

  void editPost(Post postItem, int index) {
    final listP = state.postList;
    _firebaseRepository.editPost(postItem);
    listP[index] = postItem;
    emit(
      state.copyWith(
        postList: listP,
      ),
    );
  }

  void deletePost(int index) {
    final listP = state.postList;
    _firebaseRepository.deletePost(index.toString());
    listP.removeAt(index);
    emit(
      state.copyWith(
        postList: listP,
      ),
    );
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
