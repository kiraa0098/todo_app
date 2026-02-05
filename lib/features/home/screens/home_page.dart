import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/common/helper/secure_storage_helper.dart';
import 'package:todo_app/common/widgets/connection_lost_background.dart';

import '../bloc/connection_bloc.dart' as home_bloc;
import '../widgets/add_options_sheet.dart';
import '../widgets/home_sidebar.dart';
import 'note/note_home_page.dart';
import 'todo/todo_home_page.dart';

enum HomeSection { notes, todos }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => home_bloc.ConnectionBloc(),
      child: const _HomePageBody(),
    );
  }
}

class _HomePageBody extends StatefulWidget {
  const _HomePageBody();

  @override
  State<_HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<_HomePageBody> {
  HomeSection _section = HomeSection.notes;
  bool _checkingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await SecureStorageHelper.getToken();
    if (!mounted) return;
    if (token == null) {
      context.go('/login');
    } else {
      setState(() => _checkingAuth = false);
    }
  }

  void _onSidebarSelect(HomeSection section) {
    setState(() => _section = section);
    Navigator.of(context).pop(); // close drawer
  }

  Widget _buildSection() {
    switch (_section) {
      case HomeSection.notes:
        return const NoteHomePage();
      case HomeSection.todos:
        return const TodoHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingAuth) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      appBar: AppBar(),
      drawer: HomeSidebar(
        onSectionSelected: _onSidebarSelect,
        selected: _section,
      ),
      body: BlocBuilder<home_bloc.ConnectionBloc, home_bloc.ConnectionState>(
        builder: (context, state) => Stack(
          children: [
            _buildSection(),
            if (state.isConnectionLost) const ConnectionLostBackground(),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              showDragHandle: false,
              useSafeArea: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (ctx) => AddOptionsSheet(
                onAddNote: () async {
                  Navigator.of(ctx).pop();
                  await Future.microtask(() => context.push('/note-detail'));
                },
                onAddTodo: () async {
                  Navigator.of(ctx).pop();
                  await Future.microtask(() => context.push('/todo-detail'));
                },
              ),
            );
          },
          tooltip: 'Add',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
