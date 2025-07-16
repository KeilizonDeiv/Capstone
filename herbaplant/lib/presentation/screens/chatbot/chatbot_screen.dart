// lib/presentation/screens/chatbot/chatbot_screen.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'speech_to_text.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;
  bool _showMic = true;

  final SpeechService _speechService = SpeechService();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    await _speechService.initSpeech();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isTyping = true;
      _showMic = true;
    });

    _controller.clear();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': _generateBotResponse(text),
        });
        _isTyping = false;
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  String _generateBotResponse(String userMessage) {
    if (userMessage.toLowerCase().contains("oregano")) {
      return "Oregano is used for cough, inflammation, and digestion support.";
    } else {
      return "I'm still learning! Try asking about a specific herbal plant.";
    }
  }

  Widget _buildMessage(String role, String text) {
    final isUser = role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : AppColors.textDark,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Column(
                children: const [
                  Text(
                    'HerbaBot',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Divider(thickness: 1, height: 20),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 80),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTyping && index == _messages.length) {
                    return _buildMessage('bot', "Typing...");
                  }
                  final message = _messages[index];
                  return _buildMessage(message['role']!, message['text']!);
                },
              ),
            ),
            const Divider(height: 1),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Type your question...",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() => _showMic = value.trim().isEmpty);
                      },
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  _showMic
                      ? IconButton(
                          icon: const Icon(Icons.mic, color: AppColors.primary),
                          onPressed: () {
                            _speechService.startListening((text) {
                              setState(() {
                                _controller.text = text;
                                _showMic = false;
                              });
                            });
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.send, color: AppColors.primary),
                          onPressed: _sendMessage,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
