import 'package:flutter/material.dart';

class AddOptionsSheet extends StatelessWidget {
  final VoidCallback onAddNote;
  final VoidCallback onAddTodo;

  const AddOptionsSheet({
    super.key,
    required this.onAddNote,
    required this.onAddTodo,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // grab handle
            Container(
              width: 42,
              height: 4,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(99),
              ),
            ),

            _KeepActionRow(
              icon: Icons.note_add_outlined,
              label: 'Add note',
              onTap: onAddNote,
            ),
            const SizedBox(height: 4),
            _KeepActionRow(
              icon: Icons.check_box_outlined,
              label: 'Add todo',
              onTap: onAddTodo,
            ),
          ],
        ),
      ),
    );
  }
}

class _KeepActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _KeepActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 22, color: cs.onSurfaceVariant),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
