import 'dart:io';
import 'package:flutter/material.dart';
import 'package:herbaplant/services/prompt_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/chat_widget.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> _handleInitialImage() async {
    final file = widget.imageFile;
    if (file != null) {
      final exists = await file.exists();
      final length = await file.length();
      final isValid = exists && length > 0;

      if (isValid) {
        setState(() {
          _messages.add({
            'role': 'user',
            'imagePath': file.path,
          });
          _isTyping = true;
        });

        try {
          final response =
              await PromptService.handlePrompt("", XFile(file.path));

          if (response.containsKey("error")) {
            String errorMessage = response["error"];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("⚠️ $errorMessage")),
            );
          }

          final botResponse =
              response["response"]?.toString() ?? "No response from server";

          setState(() {
            _messages.add({
              'role': 'bot',
              'text': botResponse,
            });
            _isTyping = false;
          });
        } catch (e) {
          setState(() {
            _messages.add({
              'role': 'bot',
              'text': "An error occurred: $e",
            });
            _isTyping = false;
          });
        }
      } else {
        setState(() {
          _messages.add({
            'role': 'user',
            'text': '[Image could not be loaded]',
          });
          _messages.add({
            'role': 'bot',
            'text': 'Sorry, I couldn’t identify the image you provided.',
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ ${response["error"]}")),
        );
      }

      final botResponse = response["response"] ?? "No response from server";

      setState(() {
        _messages.add({'role': 'bot', 'text': botResponse});
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
      _messages.add({
        'role': 'user',
        'imagePath': image.path,
      });
      _isTyping = true;
    });

    try {
      final response = await PromptService.handlePrompt("", image);

      if (response.containsKey("error")) {
        String errorMessage = response["error"];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ $errorMessage")),
        );
      }

      final botResponse =
          response["response"]?.toString() ?? "No response from server";

      setState(() {
        _messages.add({
          'role': 'bot',
          'text': botResponse,
        });
        _isTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': "An error occurred: $e",
        });
        _isTyping = false;
      });
    }
  }

  Widget _buildMessage(Map<String, String> message) {
    final timestamp = TimeOfDay.now().format(context);

    if (message.containsKey('imagePath')) {
      return ImageMessageBubble(
        imagePath: message['imagePath']!,
        isUser: message['role'] == 'user',
      );
    } else if (message['role'] == 'user') {
      return UserMessageBubble(text: message['text']!, time: timestamp);
    } else if (message['role'] == 'bot') {
      return _buildBotMessage(message['text']!, timestamp);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildBotMessage(String text, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        "⚠️ Disclaimer: Herby is not a medical professional. This information is for educational purposes only and should not replace advice from a qualified healthcare provider. If you experience severe symptoms, please seek medical attention immediately.",
        style: TextStyle(
          fontSize: 11,
          fontStyle: FontStyle.italic,
          color: Colors.grey[600],
          height: 1.3,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
          children: const [
            Icon(Icons.child_care_outlined, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Herby",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
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

            // 👇 Disclaimer permanently above the input field
            _buildDisclaimer(),

            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: _sendMessage,
              decoration: const InputDecoration(
                hintText: 'Ask Herby about Herbal Plants...',
                hintStyle: TextStyle(
                  color: Colors.grey,
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