import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/chat_widget.dart';

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
        // Display user image
        setState(() {
          _messages.add({
            'role': 'user',
            'imagePath': file.path,
          });
          _isTyping = true;
        });

        await Future.delayed(const Duration(seconds: 2));

        // Simulated bot response for valid image
        setState(() {
          _messages.add({
            'role': 'bot',
            'text': _getBotInfoFromImage(file),
          });
          _isTyping = false;
        });
      } else {
        // Image invalid — notify user and show bot's error response
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
    // Simulate analysis — in future, replace with ML/API logic
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
      return BotMessageBubble(text: message['text']!, time: timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Herbabot'),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primary),
            onPressed: () => _sendMessage(_controller.text),
          ),
        ],
      ),
    );
  }
}
