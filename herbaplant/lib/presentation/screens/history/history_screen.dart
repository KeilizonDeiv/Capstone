// lib/presentation/screens/history/history_screen.dart

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/history_item_widget.dart';
import '../../widgets/confirmation_dialog.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Map<String, String>> _history = [
    {
      'title': 'Monstera Deliciosa',
      'subtitle': 'A user’s progressive history into the care...'
    },
    {
      'title': 'Snake Plant (Sansevieria)',
      'subtitle': 'Exploring indoor maintenance routines...'
    },
    {
      'title': 'Aloe Vera',
      'subtitle': 'Herbal plant care to harvesting aloe gel for...'
    },
    // Add more entries here...
  ];

  final Set<int> _selectedIndexes = {};
  bool _isEditMode = false;

  void _toggleEditMode() {
    setState(() => _isEditMode = !_isEditMode);
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  void _deleteSelected() {
  if (_selectedIndexes.isEmpty) return;

  showDialog(
    context: context,
    builder: (context) => ConfirmationDialog(
      title: "Delete Selected History?",
      message: "Are you sure you want to delete the selected items?",
      onConfirm: () {
        setState(() {
          final indexes = _selectedIndexes.toList()..sort((a, b) => b.compareTo(a));
          for (final i in indexes) {
            _history.removeAt(i);
          }
          _selectedIndexes.clear();
          _isEditMode = false;
        });
        Navigator.of(context).pop();
      },
      onCancel: () => Navigator.of(context).pop(),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("History"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isEditMode && _selectedIndexes.isNotEmpty
                ? _deleteSelected
                : _toggleEditMode,
            child: Text(
              _isEditMode && _selectedIndexes.isNotEmpty
                  ? "Delete"
                  : (_isEditMode ? "Done" : "Edit"),
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];
          return HistoryItemWidget(
            title: item['title']!,
            subtitle: item['subtitle']!,
            isSelected: _selectedIndexes.contains(index),
            showDelete: _isEditMode,
            onDelete: () {
              showDialog(
                context: context,
                builder: (context) => ConfirmationDialog(
                  title: "Delete Entry?",
                  message: "Are you sure you want to delete '${_history[index]['title']}'?",
                  onConfirm: () {
                    setState(() {
                      _history.removeAt(index);
                      _selectedIndexes.remove(index);
                    });
                    Navigator.of(context).pop();
                  },
                  onCancel: () => Navigator.of(context).pop(),
                ),
              );
            },


            onSelected: _isEditMode ? () => _toggleSelection(index) : null,
            onTap: _isEditMode
                ? null
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Tapped: ${item['title']}")),
                    );
                  },
          );
        },
      ),
    );
  }
}
