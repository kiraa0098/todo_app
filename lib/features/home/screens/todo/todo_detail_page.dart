import 'package:flutter/material.dart';
import 'package:todo_app/common/widgets/skeleton_loader.dart';

class TodoDetailPage extends StatefulWidget {
  const TodoDetailPage({super.key});

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final List<_TodoItem> _items = [_TodoItem()];
  bool _hasChanged = false;
  bool _isSaving = false;

  void _onChanged() {
    if (!_hasChanged) setState(() => _hasChanged = true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final item in _items) {
      item.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Todo')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.next,
                maxLines: 1,
                onChanged: (_) => _onChanged(),
              ),
              const SizedBox(height: 12),
              ..._items.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                return Row(
                  children: [
                    Checkbox(
                      value: item.done,
                      onChanged: (val) {
                        setState(() {
                          item.done = val ?? false;
                        });
                        _onChanged();
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: item.controller,
                        decoration: const InputDecoration(
                          hintText: 'List item',
                          border: InputBorder.none,
                        ),
                        onChanged: (_) => _onChanged(),
                        onSubmitted: (_) {
                          if (idx == _items.length - 1 &&
                              item.controller.text.trim().isNotEmpty) {
                            setState(() {
                              _items.add(_TodoItem());
                            });
                          }
                        },
                      ),
                    ),
                    if (_items.length > 1)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _items.removeAt(idx);
                          });
                          _onChanged();
                        },
                      ),
                  ],
                );
              }),
              const SizedBox(height: 24),
              if (_isSaving)
                const Center(child: SkeletonLoader(rows: 1, columns: 2)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodoItem {
  final TextEditingController controller = TextEditingController();
  bool done = false;
}
