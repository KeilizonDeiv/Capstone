import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:herbaplant/presentation/screens/plant_info/plant_info.dart';
import 'package:herbaplant/presentation/screens/plant_info/plant_info_screen.dart';
import 'package:herbaplant/presentation/screens/profile/profilesettings/app_settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
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
  String _selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => _isLoading = true);

    try {
      final userHistory = await UserService.getUserHistory();
      final imageHistory = await UserService.getImageHistory();
      final chatHistory = await UserService.getChatHistory();

      final Map<int, Map<String, dynamic>> unique = {};
      for (final item in [...userHistory, ...imageHistory, ...chatHistory]) {
        final id = item['id'];
        if (id != null) unique[id] = item;
      }

      final combined = unique.values.toList();

      combined.sort((a, b) {
        final aTime = DateTime.tryParse(a['timestamp']?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = DateTime.tryParse(b['timestamp']?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });

      setState(() {
        _history = combined;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("⚠️ Error loading history: $e");
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) _selectedIndexes.clear();
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

  void _deleteSelected() async {
    if (_selectedIndexes.isEmpty) return;

    final selectedItems = _selectedIndexes.map((i) => _history[i]).toList();
    final ids = selectedItems
        .map((item) => item['id'])
        .where((id) => id != null)
        .cast<int>()
        .toList();

    final appSettings = Provider.of<AppSettings>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: appSettings.t('deleteSelectedHistory'),
        message: appSettings
            .t('deleteConfirmation')
            .replaceFirst('{count}', ids.length.toString()),
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );

    if (confirmed != true) return;

    final success = await UserService.deleteHistoryItems(ids);
    if (success) {
      await _fetchHistory(); // ✅ refresh from backend
      setState(() {
        _selectedIndexes.clear();
        _isEditMode = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appSettings
                .t('deleteSuccess')
                .replaceFirst('{count}', ids.length.toString()),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appSettings.t('deleteFailed'))),
      );
    }
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
      return timestamp;
    }
  }

  /// Filter selection menu
  void _showFilterOptions() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const Text(
            "Filter History",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.all_inbox_rounded),
            title: const Text("All"),
            onTap: () => Navigator.pop(context, "All"),
          ),
          ListTile(
            leading: const Icon(Icons.eco_rounded),
            title: const Text("Leafy Plants"),
            onTap: () => Navigator.pop(context, "Leafy"),
          ),
          ListTile(
            leading: const Icon(Icons.local_florist_rounded),
            title: const Text("Fruity Plants"),
            onTap: () => Navigator.pop(context, "Fruity"),
          ),
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline_rounded),
            title: const Text("Chats"),
            onTap: () => Navigator.pop(context, "Chat"),
          ),
          ListTile(
            leading: const Icon(Icons.image_rounded),
            title: const Text("Images"),
            onTap: () => Navigator.pop(context, "Image"),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );

    if (selected != null && mounted) {
      setState(() => _selectedFilter = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appSettings = Provider.of<AppSettings>(context);

    // ✅ Apply filters
    final filteredHistory = _history.where((item) {
      final response = item['response']?.toString().toLowerCase() ?? '';
      final imgUrl = item['img_url']?.toString() ?? '';
      final hasImage = imgUrl.isNotEmpty;
      bool isPlant = false;

      try {
        final decoded = jsonDecode(response);
        if (decoded is Map && decoded.containsKey("name")) {
          isPlant = true;
        }
      } catch (_) {}

      switch (_selectedFilter) {
        case "Leafy":
          return response.contains("leaf") || response.contains("leaves");
        case "Fruity":
          return response.contains("fruit") || response.contains("seed");
        case "Chat":
          return !isPlant && !hasImage;
        case "Image":
          return hasImage && !isPlant;
        default:
          return true;
      }
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
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
            Text(
              appSettings.t('history'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            if (_isEditMode) ...[
              const Spacer(),
              Text(
                appSettings
                    .t('selectedCount')
                    .replaceFirst('{count}', _selectedIndexes.length.toString()),
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
            ),
          ],
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded, color: Colors.white),
            tooltip: "Filter history",
            onPressed: _showFilterOptions,
          ),
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
                  ? "${appSettings.t('delete')} (${_selectedIndexes.length})"
                  : (_isEditMode ? appSettings.t('done') : appSettings.t('edit')),
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
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : filteredHistory.isEmpty
            ? _buildEmptyState(appSettings)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🧭 Conversations count header
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    color: isDark ? Colors.grey[900] : Colors.grey.shade50,
                    child: Text(
                      "Conversations: ${filteredHistory.length} / ${_history.length} (${_selectedFilter})",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // 🧾 History list
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      itemCount: filteredHistory.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 0.5,
                        color: isDark
                            ? Colors.grey[800]
                            : Colors.grey.shade100,
                        indent: 60,
                      ),
                      itemBuilder: (context, index) => _buildHistoryItem(
                          filteredHistory[index], isDark, appSettings),
                    ),
                  ),
                ],
              ),
        );
  }

  Widget _buildHistoryItem(
      Map<String, dynamic> item, bool isDark, AppSettings appSettings) {
    final responseStr = item['response']?.toString() ?? item['title'] ?? '';
    final imgUrl = item['img_url']?.toString() ?? '';
    final timestamp = item['timestamp']?.toString() ?? item['date'] ?? '';
    bool isPlant = false;

    String cleaned = responseStr
        .replaceAll(RegExp(r'```json', caseSensitive: false), '')
        .replaceAll(RegExp(r'```', caseSensitive: false), '')
        .trim();

    String titleText = cleaned.split("\n").first;

    if (!isPlant && imgUrl.isNotEmpty) {
      titleText = "🖼️ AI-generated image";
    } else if (!isPlant && imgUrl.isEmpty) {
      titleText = "💬 Chat Prompt";
    }

    try {
      final decoded = jsonDecode(cleaned);
      if (decoded is Map) {
        if (decoded.containsKey("name") && decoded["name"] != null) {
          final name = decoded["name"].toString().trim();
          if (name.isNotEmpty && name.toLowerCase() != "n/a") {
            isPlant = true;
            titleText = name;
          } else {
            titleText = "We couldn't detect a valid herbal plant.";
          }
        } else if (decoded.containsKey("error") &&
            decoded.containsKey("message")) {
          titleText = "⚠️ ${decoded["error"]}";
        }
      }
    } catch (_) {
      titleText = cleaned.split("\n").first;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        leading: imgUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  imgUrl,
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    color: isDark ? Colors.white70 : Colors.grey,
                  ),
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
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _formatTimestamp(timestamp),
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white70 : Colors.grey.shade600,
          ),
        ),
        trailing: _isEditMode
            ? Checkbox(
                value: _selectedIndexes.contains(_history.indexOf(item)),
                onChanged: (_) =>
                    _toggleSelection(_history.indexOf(item)),
                activeColor: AppColors.primary,
              )
            : Icon(Icons.arrow_forward_ios,
                size: 15,
                color:
                    isDark ? Colors.white54 : Colors.grey.shade400),
        onTap: _isEditMode
            ? () => _toggleSelection(_history.indexOf(item))
            : () => _onHistoryItemTap(item),
      ),
    );
  }

  Widget _buildEmptyState(AppSettings appSettings) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history,
              size: 64,
              color: isDark ? Colors.white30 : Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            appSettings.t('noHistory'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            appSettings.t('yourHistoryAppearsHere'),
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _cleanHistoryResponse(String raw) {
    String cleaned = raw
        .replaceAll(RegExp(r'```json', caseSensitive: false), '')
        .replaceAll(RegExp(r'```', caseSensitive: false), '')
        .trim();
    try {
      final decoded = jsonDecode(cleaned);
      if (decoded is Map) {
        if (decoded.containsKey("error") && decoded.containsKey("message")) {
          return "⚠️ ${decoded["error"]}\n\n${decoded["message"]}";
        } else if (decoded.containsKey("name") &&
            decoded.containsKey("description")) {
          return "${decoded["name"]}\n\n${decoded["description"]}";
        }
      }
    } catch (_) {}
    return cleaned;
  }

  bool _looksLikePlant(String? responseStr) {
    if (responseStr == null || responseStr.trim().isEmpty) return false;
    try {
      final cleaned = responseStr
          .replaceAll(RegExp(r'```json', caseSensitive: false), '')
          .replaceAll(RegExp(r'```', caseSensitive: false), '')
          .trim();
      final dynamic decoded = jsonDecode(cleaned);
      if (decoded is Map && decoded.containsKey("name")) return true;
    } catch (_) {}
    return false;
  }

  void _onHistoryItemTap(Map<String, dynamic> item) {
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    final responseStr = item['response']?.toString() ?? item['title'] ?? '';
    final imgUrl = item['img_url']?.toString() ?? '';

    try {
      final cleaned =
          responseStr.replaceAll(RegExp(r"^```json|```$"), "").trim();
      final decoded = jsonDecode(cleaned);

      if (decoded is Map && decoded.containsKey("name")) {
        final plant = PlantInfo.fromJson(Map<String, dynamic>.from(decoded));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                PlantInfoScreen(plant: plant, imageUrl: imgUrl),
          ),
        );
        return;
      }
    } catch (_) {}

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          _looksLikePlant(responseStr)
              ? appSettings.t('chatPrompt')
              : (imgUrl.isNotEmpty
                  ? "Generated Image"
                  : appSettings.t('chatPrompt')),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imgUrl.isNotEmpty && !_looksLikePlant(responseStr)) ...[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                      height: 180,
                      errorBuilder:
                          (context, error, stackTrace) => const Padding(
                        padding: EdgeInsets.all(16),
                        child: Icon(Icons.broken_image,
                            color: Colors.grey, size: 60),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                _cleanHistoryResponse(responseStr),
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 12),
              Text(
                "${appSettings.t('date')}: ${_formatTimestamp(item['timestamp']?.toString() ?? item['date'] ?? '')}",
                style:
                    const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              appSettings.t('close'),
              style: const TextStyle(
                color: Color(0xFF0C553B), // 🌿 same green as your app theme
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
