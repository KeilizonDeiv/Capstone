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
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Stack(
          children: [
            // Delete Button (closer to the right edge)
            if (showDelete)
              Positioned(
                top: 0,
                bottom: 0,
                right: 5,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ),

            // Content with reduced right margin
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: showDelete ? 20 : 0),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
                onTap: onTap,
                onLongPress: onSelected,
                title: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13),
                ),
                trailing: onSelected != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 1.0),
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (_) => onSelected?.call(),
                          activeColor: AppColors.primary,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      );
    }

}
