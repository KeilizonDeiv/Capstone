import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:herbaplant/main.dart' show navigatorKey;

import '../../../routes/routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;
  String _username = "John Doe";
  String _email = "john.doe@example.com";

  bool _showUsernameFields = false;
  bool _showEmailFields = false;
  bool _showPasswordFields = false;

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureRetypePassword = true;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  void _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
    });
  }

  void _saveNotificationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _ProfileSection(username: _username, email: _email),
          const Divider(height: 40),
          const _SectionHeader(title: 'Profile Management'),

          ExpansionTile(
            leading: const Icon(Icons.person, color: Colors.green),
            title: const Text('Change Username'),
            children: _showUsernameFields ? _buildUsernameFields() : [],
            onExpansionChanged: (expanded) => setState(() => _showUsernameFields = expanded),
          ),
          ExpansionTile(
            leading: const Icon(Icons.email, color: Colors.green),
            title: const Text('Change Email'),
            children: _showEmailFields ? _buildEmailFields() : [],
            onExpansionChanged: (expanded) => setState(() => _showEmailFields = expanded),
          ),
          ExpansionTile(
            leading: const Icon(Icons.lock, color: Colors.green),
            title: const Text('Change Password'),
            children: _showPasswordFields ? _buildPasswordFields() : [],
            onExpansionChanged: (expanded) => setState(() => _showPasswordFields = expanded),
          ),

          const Divider(height: 20),
          const _SectionHeader(title: 'App Preferences'),
          SwitchListTile(
            activeColor: Colors.green,
            title: const Text('Push Notifications'),
            value: _pushNotifications,
            onChanged: (value) {
              setState(() => _pushNotifications = value);
              _saveNotificationPreference(value);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    await Future.delayed(const Duration(milliseconds: 300));

    if (navigatorKey.currentContext != null) {
      GoRouter.of(navigatorKey.currentContext!).go('/login');
    }
  }
  

  List<Widget> _buildUsernameFields() {
    return [
      _buildExpansionContent([
        const Text("Enter New Username", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() => _username = usernameController.text.trim());
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Username updated!")));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Save Username", style: TextStyle(color: Colors.white)),
        ),
      ]),
    ];
  }

  List<Widget> _buildEmailFields() {
    return [
      _buildExpansionContent([
        const Text("Enter New Email", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "⚠️ You will be logged out after saving a new email.",
          style: TextStyle(fontSize: 12, color: Colors.red),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            setState(() => _email = emailController.text.trim());
            _showFullScreenLoading();
            await Future.delayed(const Duration(seconds: 2));
            _logout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Save Email", style: TextStyle(color: Colors.white)),
        ),
      ]),
    ];
  }

  List<Widget> _buildPasswordFields() {
    return [
      _buildExpansionContent([
        _passwordInputField("Old Password", oldPasswordController, _obscureOldPassword, () {
          setState(() => _obscureOldPassword = !_obscureOldPassword);
        }),
        _passwordInputField("New Password", newPasswordController, _obscureNewPassword, () {
          setState(() => _obscureNewPassword = !_obscureNewPassword);
        }),
        _passwordInputField("Retype Password", retypePasswordController, _obscureRetypePassword, () {
          setState(() => _obscureRetypePassword = !_obscureRetypePassword);
        }),
        if (_passwordError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(_passwordError!, style: const TextStyle(color: Colors.red)),
          ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (newPasswordController.text != retypePasswordController.text) {
              setState(() => _passwordError = "Passwords do not match!");
              return;
            }
            setState(() => _passwordError = null);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password updated!")));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Save Password", style: TextStyle(color: Colors.white)),
        ),
      ]),
    ];
  }

  Widget _passwordInputField(
    String label,
    TextEditingController controller,
    bool obscureText,
    VoidCallback toggleVisibility,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }

  void _showFullScreenLoading() {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(color: Colors.green),
              SizedBox(height: 20),
              Text("Logging out...\nPlease check your email.", textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String username;
  final String email;

  const _ProfileSection({required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.green.shade100,
        child: const Icon(Icons.person, size: 50, color: Colors.green),
      ),
      title: Text(username, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      subtitle: Text(email, style: const TextStyle(color: Colors.grey)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

Widget _buildExpansionContent(List<Widget> children) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );
}
