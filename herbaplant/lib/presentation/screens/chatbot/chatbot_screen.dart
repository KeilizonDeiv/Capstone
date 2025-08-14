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

        await Future.delayed(const Duration(seconds: 2));

        setState(() {
          _messages.add({
            'role': 'bot',
            'text': _getBotInfoFromImage(file),
          });
          _isTyping = false;
        });
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

  String _getBotInfoFromImage(File image) {
    return "This appears to be a sample herbal plant. Here's some basic information...";
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': message});
      _controller.clear();
      _isTyping = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': 'This is a bot reply to: "$message"',
        });
        _isTyping = false;
      });
    });
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
    } else {
      return _buildBotMessage(message['text']!, timestamp);
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
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
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
                // example: you can send the image path as a message or handle it differently
                // setState(() {
                //   _messages.add({
                //     'role': 'user',
                //     'text': '📷 Sent an image: ${image.path}',
                //   });
                // });
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
