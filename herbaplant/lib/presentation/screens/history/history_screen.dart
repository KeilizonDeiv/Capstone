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
      'subtitle':
          'A user\'s progressive history into the care and maintenance of this beautiful tropical plant...',
      'date': 'Today',
    },
    {
      'title': 'Snake Plant (Sansevieria)',
      'subtitle':
          'Exploring indoor maintenance routines and optimal growing conditions...',
      'date': 'Yesterday',
    },
    {
      'title': 'Aloe Vera',
      'subtitle':
          'Herbal plant care to harvesting aloe gel for medicinal purposes...',
      'date': 'Last week',
    },
    {
      'title': 'Fiddle Leaf Fig',
      'subtitle':
          'Documenting sunlight and watering cycles for healthy growth...',
      'date': 'Last month',
    },
    {
      'title': 'Peace Lily',
      'subtitle':
          'Tracking bloom patterns and shade preferences for indoor spaces...',
      'date': '3 weeks ago',
    },
    {
      'title': 'ZZ Plant',
      'subtitle': 'A tough plant\'s survival log under low light conditions...',
      'date': '2 days ago',
    },
    {
      'title': 'Spider Plant',
      'subtitle': 'Repotting experiences and offshoot growth management...',
      'date': 'Last month',
    },
    {
      'title': 'Jade Plant',
      'subtitle': 'Succulent propagation and leaf care journal entries...',
      'date': '2 months ago',
    },
    {
      'title': 'Pothos (Devil\'s Ivy)',
      'subtitle': 'Trailing vine trimming and rooting notes for propagation...',
      'date': '3 days ago',
    },
    {
      'title': 'Rubber Plant',
      'subtitle': 'Tracking glossy foliage and cleaning routine maintenance...',
      'date': '1 month ago',
    },
    {
      'title': 'Boston Fern',
      'subtitle': 'Humidity requirements and misting schedule documentation...',
      'date': '5 days ago',
    },
    {
      'title': 'Philodendron',
      'subtitle': 'Heart-shaped leaves care and climbing support setup...',
      'date': '1 week ago',
    },
    {
      'title': 'Calathea',
      'subtitle': 'Prayer plant movement patterns and humidity needs...',
      'date': '2 weeks ago',
    },
    {
      'title': 'Dracaena',
      'subtitle': 'Dragon tree pruning and brown tip prevention methods...',
      'date': '3 weeks ago',
    },
    {
      'title': 'Succulent Garden',
      'subtitle': 'Mixed succulent arrangement and watering schedule...',
      'date': '1 month ago',
    },
  ];

  final Set<int> _selectedIndexes = {};
  bool _isEditMode = false;

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _selectedIndexes.clear();
      }
    });
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

    final selectedCount = _selectedIndexes.length;
    final itemLabel = selectedCount > 1 ? 'items' : 'item';

    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Delete Selected History?',
        message:
            'Are you sure you want to delete $selectedCount selected $itemLabel?',
        onConfirm: () {
          setState(() {
            final sortedIndexes = _selectedIndexes.toList()
              ..sort((a, b) => b.compareTo(a));
            for (final index in sortedIndexes) {
              if (index >= 0 && index < _history.length) {
                _history.removeAt(index);
              }
            }

            _selectedIndexes.clear();
            _isEditMode = false;
          });

          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$selectedCount $itemLabel deleted.'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _selectAll() {
    setState(() {
      if (_selectedIndexes.length == _history.length) {
        _selectedIndexes.clear();
      } else {
        _selectedIndexes.clear();
        _selectedIndexes
            .addAll(List.generate(_history.length, (index) => index));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          const Text(
            "History",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          if (_isEditMode) ...[
            const Spacer(),
            Text(
              '${_selectedIndexes.length} selected',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (_isEditMode && _selectedIndexes.isNotEmpty) ...[
          IconButton(
            icon: Icon(
              _selectedIndexes.length == _history.length
                  ? Icons.deselect
                  : Icons.select_all,
              color: Colors.black,
            ),
            onPressed: _selectAll,
            tooltip: _selectedIndexes.length == _history.length
                ? 'Deselect All'
                : 'Select All',
          ),
        ],
        TextButton.icon(
          icon: Icon(
            _isEditMode && _selectedIndexes.isNotEmpty
                ? Icons.delete
                : (_isEditMode ? Icons.done : Icons.edit),
            color: _isEditMode && _selectedIndexes.isNotEmpty
                ? Colors.red
                : Colors.black,
            size: 20,
          ),
          label: Text(
            _isEditMode && _selectedIndexes.isNotEmpty
                ? "Delete (${_selectedIndexes.length})"
                : (_isEditMode ? "Done" : "Edit"),
            style: TextStyle(
              color: _isEditMode && _selectedIndexes.isNotEmpty
                  ? Colors.red
                  : Colors.black,
            ),
          ),
          onPressed: _isEditMode && _selectedIndexes.isNotEmpty
              ? _deleteSelected
              : _toggleEditMode,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    if (_history.isEmpty) return _buildEmptyState();

    return Column(
      children: [
        Container(height: 1, color: Colors.grey.shade200),
        if (_history.isNotEmpty && !_isEditMode)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            color: Colors.grey.shade50,
            child: Text(
              '${_history.length} conversation${_history.length > 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _history.length,
            separatorBuilder: (context, index) => Divider(
              height: 0.5,
              color: Colors.grey.shade100,
              indent: 60,
            ),
            itemBuilder: (context, index) => _buildHistoryItem(index),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(int index) {
    if (index >= _history.length) return const SizedBox.shrink();

    final item = _history[index];
    final isSelected = _selectedIndexes.contains(index);

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 10.0, vertical: 1),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 4),
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.chat_bubble_outline,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          title: Text(
            item['title'] ?? '',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['subtitle'] ?? '',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                item['date'] ?? '',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          trailing: _isEditMode
              ? Checkbox(
                  value: isSelected,
                  onChanged: (_) => _toggleSelection(index),
                  activeColor: AppColors.primary,
                )
              : Icon(Icons.arrow_forward_ios,
                  size: 15, color: Colors.grey.shade400),
          onTap: _isEditMode
              ? () => _toggleSelection(index)
              : () => _onHistoryItemTap(item),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No History Yet',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Your conversation history will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _onHistoryItemTap(Map<String, String> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Opening: ${item['title']}"),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
