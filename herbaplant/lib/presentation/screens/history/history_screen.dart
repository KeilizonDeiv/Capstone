import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:herbaplant/presentation/screens/plant_info/plant_info.dart';
import 'package:herbaplant/presentation/screens/plant_info/plant_info_screen.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/history_item_widget.dart';
import '../../widgets/confirmation_dialog.dart';
import 'package:herbaplant/services/user_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _history = [];
  final Set<int> _selectedIndexes = {};
  bool _isEditMode = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => _isLoading = true);

    final userHistory = await UserService.getUserHistory();
    final imageHistory = await UserService.getImageHistory();

    // merge both lists
    final combined = [...userHistory, ...imageHistory];

    // sort newest to oldest using timestamp if available
    combined.sort((a, b) {
      final aTime = DateTime.tryParse(a['timestamp']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = DateTime.tryParse(b['timestamp']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime); // newest first
    });

    setState(() {
      _history = combined;
      _isLoading = false;
    });
  }

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

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return '';
    try {
      final dt = DateTime.parse(timestamp).toLocal();
      return DateFormat("MMMM d, yyyy HH:mm").format(dt);
    } catch (e) {
      return timestamp; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0C553B),
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 5,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          const Text(
            "History",
            style: TextStyle(
              color: Colors.white,
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
              color: Colors.white,
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
                : Colors.white,
            size: 20,
          ),
          label: Text(
            _isEditMode && _selectedIndexes.isNotEmpty
                ? "Delete (${_selectedIndexes.length})"
                : (_isEditMode ? "Done" : "Edit"),
            style: TextStyle(
              color: _isEditMode && _selectedIndexes.isNotEmpty
                  ? Colors.red
                  : Colors.white,
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
        if (!_isEditMode)
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

    final imgUrl = item['img_url']?.toString() ?? '';
    final responseStr = item['response']?.toString() ?? item['title'] ?? '';
    final timestamp = item['timestamp']?.toString() ?? item['date'] ?? '';

    // Try detect if it's JSON (plant identification)
    bool isPlant = false;
    String titleText = responseStr.split("\n").first;
    try {
      final cleaned = responseStr.replaceAll(RegExp(r"^```json|```$"), "").trim();
      final decoded = jsonDecode(cleaned);
      if (decoded is Map && decoded.containsKey("name")) {
        isPlant = true;
        titleText = decoded["name"]; // use plant name instead of ```json
      }
    } catch (_) {
      // not JSON → chat
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          leading: isPlant && imgUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    imgUrl,
                    width: 38,
                    height: 38,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                )
              : Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.chat_bubble_outline,
                      color: AppColors.primary, size: 18),
                ),
          title: Text(
            titleText,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            _formatTimestamp(timestamp),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

  void _onHistoryItemTap(Map<String, dynamic> item) {
    final responseStr = item['response']?.toString() ?? item['title'] ?? '';
    final imgUrl = item['img_url']?.toString() ?? '';

    try {
      // Try parse JSON (plant identify mode)
      final cleaned = responseStr.replaceAll(RegExp(r"^```json|```$"), "").trim();
      final decoded = jsonDecode(cleaned);

      final plant = PlantInfo.fromJson(decoded);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PlantInfoScreen(
            plant: plant,
            imageUrl: imgUrl, // ✅ show image here
          ),
        ),
      );
    } catch (e) {
      // Not JSON → this is a chat, so NO image shown
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Plant Details"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(responseStr),
                const SizedBox(height: 10),
                Text(
                  "Date: ${_formatTimestamp(item['timestamp']?.toString() ?? item['date'] ?? '')}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }
}