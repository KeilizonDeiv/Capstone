import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:herbaplant/services/prompt_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/chat_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';


class ChatbotScreen extends StatefulWidget {
  final File? imageFile;

  const ChatbotScreen({Key? key, this.imageFile}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _handleInitialImage();
  }

  /// 🔧 Formatter: Convert backend response (JSON or String) into clean text
  String _formatBotResponse(dynamic raw) {
    try {
      if (raw is String) {
        String cleaned = raw
            .replaceAll(RegExp(r'```json', caseSensitive: false), '')
            .replaceAll(RegExp(r'```', caseSensitive: false), '')
            .replaceAll('\\n', '\n')
            .replaceAll('\\', '')
            .trim();

        try {
          final decoded = jsonDecode(cleaned);
          if (decoded is Map) return _formatPlantInfo(decoded);
        } catch (_) {
          return cleaned;
        }
        return cleaned;
      } else if (raw is Map) {
        return _formatPlantInfo(raw);
      }
    } catch (e) {
      print("⚠️ Error parsing bot response: $e");
      return raw?.toString() ?? "No response from server";
    }
    return raw?.toString() ?? "No response from server";
  }

  String _formatPlantInfo(Map data) {
    final buffer = StringBuffer();

    // Handle error messages first
    if (data.containsKey("error")) {
      final msg = data["message"] ?? "Please try again with a clearer image.";
      return "⚠️ ${data['error']}\n\n$msg";
    }

    if (data.containsKey("name")) buffer.writeln("🌿 Name: ${data['name']}");
    if (data.containsKey("scientific_name"))
      buffer.writeln("🔬 Scientific: ${data['scientific_name']}");
    if (data.containsKey("description"))
      buffer.writeln("📝 ${data['description']}");
    if (data.containsKey("benefits")) {
      final benefits = (data['benefits'] is List)
          ? (data['benefits'] as List).join(", ")
          : data['benefits'];
      buffer.writeln("💚 Benefits: $benefits");
    }
    if (data.containsKey("uses")) {
      final uses = (data['uses'] is List)
          ? (data['uses'] as List).join(", ")
          : data['uses'];
      buffer.writeln("✨ Uses: $uses");
    }
    if (data.containsKey("where_to_find"))
      buffer.writeln("📍 Where to find: ${data['where_to_find']}");
    if (data.containsKey("fun_facts"))
      buffer.writeln("🎉 Fun fact: ${data['fun_facts']}");

    return buffer.toString().trim();
  }

  Future<void> _handleInitialImage() async {
    final file = widget.imageFile;
    if (file != null) {
      final exists = await file.exists();
      final length = await file.length();
      final isValid = exists && length > 0;

      if (isValid) {
        setState(() {
          _messages.add({'role': 'user', 'imagePath': file.path});
          _isTyping = true;
        });

        try {
          final response =
              await PromptService.handlePrompt("", XFile(file.path));

          if (response.containsKey("error")) {
            _showError(response["error"].toString());
          }

          final botResponse = _formatBotResponse(response["response"]);

          setState(() {
            _messages.add({'role': 'bot', 'text': botResponse});
            _isTyping = false;
          });
        } catch (e) {
          setState(() {
            _messages.add({'role': 'bot', 'text': "An error occurred: $e"});
            _isTyping = false;
          });
        }
      } else {
        setState(() {
          _messages
              .add({'role': 'user', 'text': '[Image could not be loaded]'});
          _messages.add({
            'role': 'bot',
            'text': 'Sorry, I couldn’t identify the image you provided.'
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid or unreadable image.")),
        );
      }
    }
  }

  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': message});
      _controller.clear();
      _isTyping = true;
    });

    try {
      final response = await PromptService.chatPrompt(message);

      if (response.containsKey("error")) {
        _showError(response["error"].toString());
      }

      final resp = response["response"] ?? {};
      String botText = "";
      if (resp["text"] != null && resp["text"].toString().isNotEmpty) {
        botText = resp["text"].toString();
      } else {
        botText = _formatBotResponse(resp);
      }
      final imageUrl = resp["image_url"] ?? "";

      // 🧠 Detect if response implies non-herbal or unclear content
      final lowerText = botText.toLowerCase();
      final isNonHerbal = lowerText.contains("not a herbal") ||
          lowerText.contains("non herbal") ||
          lowerText.contains("unclear") ||
          lowerText.contains("unable to identify") ||
          lowerText.contains("cannot") ||
          lowerText.contains("unrelated") ||
          lowerText.contains("please provide") ||
          lowerText.contains("image may not represent");

      setState(() {
        if (isNonHerbal) {
          _messages.add({
            'role': 'bot',
            'text':
                "⚠️ Please upload or generate a **clear image of a herbal plant** for accurate identification."
          });
        } else {
          _messages.add({
            'role': 'bot',
            'text': botText,
            'imageUrl': imageUrl ?? ''
          });
        }
        _isTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'text': "❌ Error: $e"});
        _isTyping = false;
      });
    }
  }

  void _sendImage(XFile image) async {
    setState(() {
      _messages.add({'role': 'user', 'imagePath': image.path});
      _isTyping = true;
    });

    try {
      final response = await PromptService.handlePrompt("", image);

      if (response.containsKey("error")) {
        _showError(response["error"].toString());
      }

      final botResponse = _formatBotResponse(response["response"]) ?? "";
      final rawText = response["response"]?["raw_text"] ?? "";

      final lowerText = (botResponse + rawText).toLowerCase();
      final isInvalid = lowerText.contains("unable to identify") ||
          lowerText.contains("not a herbal plant") ||
          lowerText.contains("unclear") ||
          lowerText.contains("please ensure the image");

      setState(() {
        if (isInvalid) {
          _messages.add({
            'role': 'bot',
            'text':
                "⚠️ Please upload a clear image of a herbal plant for accurate identification."
          });
        } else {
          _messages.add({'role': 'bot', 'text': botResponse});
        }
        _isTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'text': "An error occurred: $e"});
        _isTyping = false;
      });
    }
  }

  void _showError(String errorMessage) {
    String userFriendlyMessage;
    if (errorMessage.contains("500")) {
      userFriendlyMessage =
          "The server is currently unavailable. Please try again later.";
    } else if (errorMessage.contains("timeout")) {
      userFriendlyMessage =
          "The connection timed out. Please check your internet and try again.";
    } else {
      userFriendlyMessage =
          "Oops! Something went wrong. Please try again in a moment.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("⚠️ $userFriendlyMessage")),
    );
  }
  
  String _shortenText(String text, {int maxLength = 350}) {
    if (text.length <= maxLength) return text;
    final cutoff = text.substring(0, maxLength);
    final lastPeriod = cutoff.lastIndexOf(".");
    final endIndex = lastPeriod != -1 ? lastPeriod + 1 : maxLength;
    return text.substring(0, endIndex).trim() + " ...";
  }


  Widget _buildMessage(Map<String, String> message) {
    final timestamp = TimeOfDay.now().format(context);
    final role = message['role'];

    if (message.containsKey('imagePath') && message['imagePath'] != null) {
      return ImageMessageBubble(
        imagePath: message['imagePath']!,
        isUser: role == 'user',
      );
    }

    if (role == 'bot' &&
    message.containsKey('imageUrl') &&
    message['imageUrl'] != null &&
    message['imageUrl']!.isNotEmpty) {
  final text = message['text'] ?? '';

  // 🧩 Check if this looks like structured plant info JSON
  try {
    final decoded = jsonDecode(text);
    if (decoded is Map && decoded.containsKey("name")) {
      final name = decoded["name"] ?? "Unknown Plant";
      final sciName = decoded["scientific_name"] ?? "";
      final desc = decoded["description"] ?? "";
      final uses = List<String>.from(decoded["uses"] ?? []);
      final benefits = List<String>.from(decoded["benefits"] ?? []);
      final imageUrl = message['imageUrl']!;

      return BotPlantInfoBubble(
        name: name,
        scientificName: sciName,
        description: desc,
        uses: uses,
        benefits: benefits,
        imageUrl: imageUrl,
      );
    }
  } catch (_) {}

  // 🧩 Fallback: show normal image first, then short text
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.white,
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[700]!
              : Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ Image first
          if (message['imageUrl'] != null && message['imageUrl']!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                message['imageUrl']!,
                fit: BoxFit.cover,
                height: 230,
                width: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                },
                errorBuilder: (context, error, stack) => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Icon(Icons.broken_image,
                      color: Colors.redAccent, size: 40),
                ),
              ),
            ),
          const SizedBox(height: 10),

          // 📝 Shortened text next
          if (text.isNotEmpty)
            Text(
              _shortenText(text),
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
        ],
      ),
    ),
  );
  }

    if (role == 'user' && message['text'] != null) {
      return UserMessageBubble(text: message['text']!, time: timestamp);
    }

    if (role == 'bot' && message['text'] != null) {
      return _buildBotMessage(message['text']!, timestamp);
    }

    return const SizedBox.shrink();
  }

  Widget _buildBotMessage(String text, String time) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimer(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        "⚠️ Disclaimer: Herby is not a medical professional. This information is for educational purposes only...",
        style: TextStyle(
          fontSize: 11,
          fontStyle: FontStyle.italic,
          color: isDark ? Colors.white70 : Colors.grey[600],
          height: 1.3,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showDisclaimerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: const Text(
        "Disclaimer",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      content: const Text(
        "Image generation works best with English. "
        "If you’re using another language, the image will NOT be generated.",
        style: TextStyle(fontSize: 14, height: 1.4),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text("Got it"),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C553B),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.child_care_outlined, color: Colors.white),
            const SizedBox(width: 8),
            const Text(
              "Herby",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 4),
            // 🧠 Info icon button
            GestureDetector(
              onTap: () => _showDisclaimerDialog(context),
              child: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white70,
                size: 18,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessage(_messages[index]);
                },
              ),
            ),
            if (_isTyping)
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: BotMessageBubble(text: "Typing..."),
              ),
            _buildDisclaimer(isDark),
            _buildInputField(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: isDark ? Colors.grey[850] : Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: _sendMessage,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'Ask Herby about Herbal Plants...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF0C553B)),
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                _sendImage(image);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF0C553B)),
            onPressed: () => _sendMessage(_controller.text),
          ),
        ],
      ),
    );
  }
}

/// 🌿 Styled text section that mimics the PlantInfoScreen layout inside chat
class BotPlantInfoBubble extends StatelessWidget {
  final String name;
  final String scientificName;
  final String description;
  final List<String> uses;
  final List<String> benefits;
  final String imageUrl;

  const BotPlantInfoBubble({
    super.key,
    required this.name,
    required this.scientificName,
    required this.description,
    this.uses = const [],
    this.benefits = const [],
    this.imageUrl = '',
  });

  Widget _buildSection(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        ...items.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text("• $e",
                style: const TextStyle(fontSize: 14, height: 1.4)),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 10),

            // 🌿 Title
            Text(
              name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // 🔬 Scientific name
            if (scientificName.isNotEmpty)
              Text(
                scientificName,
                style: const TextStyle(
                    fontSize: 15, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            const SizedBox(height: 10),

            // 📝 Description
            Text(
              description,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            // 🌿 Sections
            _buildSection("Uses", uses),
            _buildSection("Health Benefits", benefits),
          ],
        ),
      ),
    );
  }
}


/// 🧠 Bot image message bubble
class BotImageBubble extends StatelessWidget {
  final String imageUrl;

  const BotImageBubble({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 250,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stack) => const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(Icons.broken_image, color: Colors.redAccent, size: 40),
            ),
          ),
        ),
      ),
    );
  }
}
