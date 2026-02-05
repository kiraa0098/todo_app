import 'package:flutter/material.dart';

class ItemGrid<T> extends StatelessWidget {
  final List<T> items;
  final int crossAxisCount;
  final double childAspectRatio;
  final Widget Function(BuildContext, T, bool selected) itemBuilder;
  final void Function(T)? onTap;
  final void Function(T)? onLongPress;
  final T? selectedItem;

  const ItemGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.95,
    this.onTap,
    this.onLongPress,
    this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final selected = selectedItem != null && selectedItem == item;
        return GestureDetector(
          onTap: onTap != null ? () => onTap!(item) : null,
          onLongPress: onLongPress != null ? () => onLongPress!(item) : null,
          child: itemBuilder(context, item, selected),
        );
      },
    );
  }
}
