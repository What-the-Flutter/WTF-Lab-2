import 'package:bloc/bloc.dart';
import '../repo/firebase/messages_repository.dart';
import '../utils/category.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final MessagesRepository messageRepository = MessagesRepository();

  CategoryCubit() : super(CategoryState(categories: [], isUnderChoice: false));

  void showCategories() {
    emit(
      state.copyWith(
        isUnderChoice: state.isUnderChoice ? false : true,
      ),
    );
  }

  void closeCategories() => emit(state.copyWith(isUnderChoice: false));
}

class CategoryState {
  final List<Category> categories;
  final bool isUnderChoice;

  CategoryState({required this.categories, required this.isUnderChoice});

  CategoryState copyWith({
    List<Category>? categories,
    bool? isUnderChoice,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isUnderChoice: isUnderChoice ?? this.isUnderChoice,
    );
  }
}

// const _categories = [
//   Category(
//       icon: Icon(
//         IconData(
//           0xf455,
//           fontFamily: 'MaterialIcons',
//         ),
//       ),
//       title: 'Car'),
//   Category(
//     icon: Icon(
//       IconData(
//         0xf4b8,
//         fontFamily: 'MaterialIcons',
//       ),
//     ),
//     title: 'Weather',
//   ),
//   Category(
//     icon: Icon(
//       IconData(
//         0xef8a,
//         fontFamily: 'MaterialIcons',
//       ),
//     ),
//     title: 'Home',
//   ),
//   Category(
//     icon: Icon(
//       IconData(
//         0xf4d2,
//         fontFamily: 'MaterialIcons',
//       ),
//     ),
//     title: 'Relax',
//   ),
//   Category(
//     icon: Icon(
//       IconData(
//         0xf4b1,
//         fontFamily: 'MaterialIcons',
//       ),
//     ),
//     title: 'Plans',
//   ),
// ];
