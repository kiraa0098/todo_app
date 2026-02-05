import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import 'features/account/screens/account_creation_page.dart';
import 'features/auth/screens/login_page.dart';
import 'features/home/screens/home_page.dart';
import 'features/home/screens/note/note_detail_page.dart';
import 'features/home/screens/todo/todo_detail_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const AccountCreationPage(),
    ),
    GoRoute(
      path: '/note-detail',
      builder: (context, state) => const NoteDetailPage(),
    ),
    GoRoute(
      path: '/todo-detail',
      builder: (context, state) => const TodoDetailPage(),
    ),
  ],
);

Future<void> main() async {
  await dotenv.load();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'TODO App',
      debugShowCheckedModeBanner: false,
    );
  }
}
