import 'package:flutter/material.dart';
import 'package:todo_app/features/home/models/note_model.dart';

class NoteGridItem extends StatelessWidget {
  final NoteModel note;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;

  const NoteGridItem({
    Key? key,
    required this.note,
    this.onTap,
    this.onLongPress,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.07)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.45)
                : Theme.of(context).dividerColor.withOpacity(0.18),
            width: selected ? 2.2 : 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.title.isNotEmpty)
              Text(
                note.title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            if (note.title.isNotEmpty) const SizedBox(height: 10),
            Text(
              note.text,
              style: TextStyle(
                fontSize: 15,
                color: selected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.85)
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
