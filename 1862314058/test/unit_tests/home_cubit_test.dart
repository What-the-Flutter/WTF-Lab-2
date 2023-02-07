// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// import 'package:flutter/material.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:chat_app/repository/anonymous_auth.dart';
// import 'package:chat_app/data/models/post.dart';
// import 'package:chat_app/presentation/home/home_state.dart';
//
// class MockHomePageCubit extends MockCubit<HomeState> implements HomeCubit {
//   MockUser get mockUser => MockUser(
//         isAnonymous: true,
//       );
// }
//
// class FakePostPageState extends Fake implements HomeState {}
//
// void main() {
//   setUpAll(() {
//     registerFallbackValue(FakePostPageState());
//   });
//
//   final mockUser = MockUser(
//     isAnonymous: true,
//   );
//
//   final examplePost1 = Post(
//     id: 1,
//     title: 'Post 1',
//     createPostTime: '30/01/2023',
//   );
//
//   final examplePost2 = [
//     Post(
//       id: 22,
//       title: 'Post 2',
//       createPostTime: '30/01/2023',
//     ),
//     Post(
//       id: 23,
//       title: 'Post 22',
//       createPostTime: '30/01/2023',
//     ),
//     Post(
//       id: 24,
//       title: 'Post 222',
//       createPostTime: '30/01/2023',
//     ),
//   ];
//
//   group(
//     'Home Cubit tests',
//     () {
//       late HomeCubit homeCubit;
//       setUp(() {
//         WidgetsFlutterBinding.ensureInitialized();
//         homeCubit = MockHomePageCubit();
//       });
//
//       blocTest(
//         'init Home Cubit',
//         build: () => homeCubit,
//         expect: () => [],
//       );
//
//       blocTest<HomeCubit, HomeState>(
//         'Add post',
//         build: () => homeCubit,
//         act: (cubit) {
//           cubit.addPost(examplePost1);
//         },
//         expect: () => [
//           HomeState(
//             postList: [examplePost1],
//           ),
//           HomeState()
//         ],
//       );
//     },
//   );
// }
