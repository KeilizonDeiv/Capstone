// lib/presentation/widgets/history_item_widget.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class HistoryItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback? onSelected;
  final VoidCallback? onTap;
  final bool showDelete;
  final VoidCallback? onDelete;

  const HistoryItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.isSelected = false,
    this.onSelected,
    this.onTap,
    this.showDelete = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Delete Button background
        if (showDelete)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ),
          ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(right: showDelete ? 60 : 0),
          child: ListTile(
            onTap: onTap,
            onLongPress: onSelected,
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: onSelected != null
                ? Checkbox(
                    value: isSelected,
                    onChanged: (_) => onSelected?.call(),
                    activeColor: AppColors.primary,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
