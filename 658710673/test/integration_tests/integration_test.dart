import 'package:chat_journal/data/firebase_provider.dart';
import 'package:chat_journal/data/shared_preferences_provider.dart';
import 'package:chat_journal/models/category.dart';
import 'package:chat_journal/home_page/home_page.dart';
import 'package:chat_journal/home_page/home_cubit.dart';
import 'package:chat_journal/create_category_page/create_category_page.dart';
import 'package:chat_journal/main.dart' as app;
import 'package:chat_journal/category_page/category_page.dart';
import 'package:chat_journal/settings_page/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

typedef Callback = void Function(MethodCall call);

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class MockFirebaseProvider extends Mock implements FirebaseProvider {}

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': {},
        }
      ];
    }
    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }
    if (customHandlers != null) {
      customHandlers(call);
    }
    return null;
  });
}

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  FirebaseDatabase firebaseDatabase;
  FirebaseStorage firebaseStorage;
  SharedPreferences.setMockInitialValues({});
  const MethodChannel('plugins.flutter.io/firebase_core')
      .setMockMethodCallHandler((methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{};
    }
    return null;
  });
  setupFirebaseAuthMocks();

  const fakeData = {
    "categories": {
      "1653417292988": {
        "icon": 57943,
        "id": 1653417292988,
        "timeOfCreation": "2022-05-24T21:34:52.988441",
        "title": "family"
      },
      "1653417307813": {
        "icon": 58852,
        "id": 1653417307813,
        "timeOfCreation": "2022-05-24T21:35:07.813830",
        "title": "products"
      },
      "1653417339966": {
        "icon": 58854,
        "id": 1653417339966,
        "timeOfCreation": "2022-05-24T21:35:39.966893",
        "title": "sport"
      },
    },
    "events": {
      "1653417393614": {
        "category": 1653417307813,
        "description": "молоко\nбананы\nкурица\nсыр",
        "isBookmarked": 0,
        "sectionIcon": 57620,
        "sectionTitle": "",
        "timeOfCreation": "2022-05-24T21:36:33.614896"
      },
      "1653417432197": {
        "category": 1653417339966,
        "description": "с 3 на 5",
        "isBookmarked": 0,
        "sectionIcon": 57620,
        "sectionTitle": "",
        "timeOfCreation": "2022-05-24T21:37:12.197467"
      },
    }
  };

  MockFirebaseDatabase.instance.ref().set(fakeData);

  setUpAll(() async {
    await Firebase.initializeApp();
    firebaseDatabase = MockFirebaseDatabase.instance;
    firebaseStorage = MockFirebaseStorage();
  });

  final noteList = [
    Category.withoutId(
      'one',
      Icon(Icons.grade),
    ),
    Category.withoutId(
      'two',
      Icon(Icons.add),
    ),
  ];

  final futureCategoryList = Future<List<Category>>(() {
    return noteList;
  });

  late FirebaseProvider firebaseProvider;
  late FirebaseAuth firebaseAuth;

  final user = MockUser(
    isAnonymous: true,
  );

  final mockAdditionalUserInfo = AdditionalUserInfo(
    isNewUser: false,
    username: 'flutterUser',
    providerId: 'testProvider',
    profile: <String, dynamic>{'foo': 'bar'},
  );

  final mockCredential = EmailAuthProvider.credential(
    email: 'test',
    password: 'test',
  ) as EmailAuthCredential;

  final auth = MockFirebaseAuth();
  final mockUserPlatform = MockUserPlatform(auth, user);
  final mockUserCredPlatform = MockUserCredentialPlatform(
    FirebaseAuthPlatform.instance,
    mockAdditionalUserInfo!,
    mockCredential!,
    mockUserPlatform!,
  );

  group('end-to-end test', () {
    setUp(() {
      firebaseProvider = MockFirebaseProvider();
    });

    testWidgets('tap on the floating action button go to CreatePage', (tester) async {
      when(firebaseProvider.getAllCategories).thenAnswer((_) => futureCategoryList);
      when(auth.signInAnonymously).thenAnswer((_) => mockUserCredPlatform!);
      app.main();
      await tester.pumpAndSettle();
      expect(find.byKey(Key('text')), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(CreateCategoryPage), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(CircleAvatar), findsNWidgets(10));
      await tester.enterText(find.byType(TextField), 'Some text to input');
      expect(find.text('Some text to input'), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('tap on the statistics button from Drawer', (tester) async {
      when(databaseProvider.dbNotesList()).thenReturn(futureNoteList);
      app.main();
      await tester.pumpAndSettle();
      expect(find.byKey(Key('text')), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('Home')), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
      await tester.tap(find.byType(Drawer));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('statistics'));
      await tester.pumpAndSettle();
      expect(find.byType(StatisticsPage), findsOneWidget);
    });
  });
}
