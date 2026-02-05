import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/common/api/base_api.dart';
import 'package:todo_app/common/widgets/connection_lost_background.dart';
import 'package:todo_app/features/home/bloc/note/note_bloc.dart';
import 'package:todo_app/features/home/bloc/note/note_event.dart';
import 'package:todo_app/features/home/bloc/note/note_state.dart';
import 'package:todo_app/features/home/models/note_model.dart';
import 'package:todo_app/features/home/screens/note/note_detail_page.dart';
import 'package:todo_app/features/home/widgets/note/note_grid_item.dart';

class NoteHomePage extends StatefulWidget {
  const NoteHomePage({super.key});

  @override
  State<NoteHomePage> createState() => NoteHomePageState();
}

class NoteHomePageState extends State<NoteHomePage> {
  void refetchAndScrollTo(String noteId) {
    context.read<NoteBloc>().add(FetchNotes());
    setState(() {
      _scrollToNoteId = noteId;
    });
  }

  final ScrollController _scrollController = ScrollController();
  String? _scrollToNoteId;
  String? _selectedNoteId;

  void _handleNoteTap(BuildContext context, String? noteId) async {
    if (_selectedNoteId != null) {
      setState(() => _selectedNoteId = null);
      return;
    }
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteDetailPage(
          note: (context.read<NoteBloc>().state as NoteLoaded).notes.firstWhere(
            (n) => n.id == noteId,
          ),
        ),
      ),
    );
    context.read<NoteBloc>().add(FetchNotes());
    if (result is String) {
      setState(() {
        _scrollToNoteId = result;
      });
    }
  }

  void _handleNoteLongPress(String? noteId) {
    setState(() {
      _selectedNoteId = noteId;
    });
  }

  void _handleDelete(BuildContext context) {
    if (_selectedNoteId != null) {
      final state = context.read<NoteBloc>().state;
      if (state is NoteLoaded) {
        final note = state.notes.where((n) => n.id == _selectedNoteId).toList();
        if (note.isNotEmpty) {
          context.read<NoteBloc>().add(DeleteNote(note.first));
        }
      }
      setState(() => _selectedNoteId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteBloc(context)..add(FetchNotes()),
      child: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return _NoteDetailSkeleton();
          }
          if (state is NoteError) {
            if (state.message == BaseApi.connectionErrorTag) {
              return const ConnectionLostBackground();
            }
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is NoteLoaded) {
            final notes = state.notes;
            if (notes.isEmpty) {
              return const Center(child: Text('No notes found.'));
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollToNoteId != null) {
                final idx = notes.indexWhere((n) => n.id == _scrollToNoteId);
                if (idx >= 0 && _scrollController.hasClients) {
                  _scrollController.animateTo(
                    (idx / 2).floor() * 240.0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }
                _scrollToNoteId = null;
              }
            });
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.surface,
                title: Text(
                  'Notes',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                actions: [
                  if (_selectedNoteId != null)
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/svg/icon/trash.svg',
                        width: 26,
                        height: 26,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.error,
                          BlendMode.srcIn,
                        ),
                      ),
                      tooltip: 'Delete',
                      onPressed: () => _handleDelete(context),
                    ),
                ],
              ),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  NoteModel? selected;
                  if (_selectedNoteId != null) {
                    for (final n in notes) {
                      if (n.id == _selectedNoteId) {
                        selected = n;
                        break;
                      }
                    }
                  }
                  return GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return NoteGridItem(
                        note: note,
                        onTap: () => _handleNoteTap(context, note.id),
                        onLongPress: () => _handleNoteLongPress(note.id),
                        selected: selected == note,
                      );
                    },
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'notes_fab',
                onPressed: () => _handleNoteTap(context, null),
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.add),
              ),
            );
          }
          return _NoteDetailSkeleton();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _NoteDetailSkeleton extends StatelessWidget {
  const _NoteDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final skeletonHeight = MediaQuery.of(context).size.height * 0.75;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SizedBox(
        height: skeletonHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _ShimmerBox(width: double.infinity, height: 24, borderRadius: 8),
            const SizedBox(height: 12),
            _ShimmerBox(width: 180, height: 16, borderRadius: 8),
            const SizedBox(height: 24),

            Expanded(
              child: _ShimmerBox(
                width: double.infinity,
                height: double.infinity,
                borderRadius: 12,
              ),
            ),

            const SizedBox(height: 24),
            _ShimmerBox(width: 140, height: 16, borderRadius: 8),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                _ShimmerBox(width: 60, height: 16, borderRadius: 8),
                const SizedBox(width: 16),
                Expanded(child: _ShimmerBox(height: 16, borderRadius: 8)),
              ],
            ),
            const SizedBox(height: 12),
            _ShimmerBox(width: double.infinity, height: 16, borderRadius: 8),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  const _ShimmerBox({
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = width == double.infinity
            ? constraints.maxWidth
            : width;
        final boxHeight = height == double.infinity
            ? constraints.maxHeight
            : height;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: -1, end: 2),
          duration: const Duration(milliseconds: 1200),
          builder: (context, value, child) {
            return Container(
              width: boxWidth,
              height: boxHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.grey.shade300,
                    Colors.grey.shade100,
                    Colors.grey.shade300,
                  ],
                  stops: const [0.1, 0.5, 0.9],
                  transform: _SlidingGradientTransform(value),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}
