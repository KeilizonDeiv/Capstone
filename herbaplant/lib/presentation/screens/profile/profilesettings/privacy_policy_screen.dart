import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color cardColor = isDark ? Colors.grey[900]! : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black87;
    Color subTextColor = isDark ? Colors.white70 : Colors.grey[600]!;

    Widget buildPolicyCard(IconData icon, String title, String content,
      {Color? iconColor, bool isLast = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✅ Icon with vertical line
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (iconColor ?? const Color(0xFF0C553B)).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor ?? const Color(0xFF0C553B)),
              ),
              if (!isLast) // don't draw line on the last item
                Container(
                  width: 2,
                  height: 50,
                  color: (iconColor ?? const Color(0xFF0C553B)).withOpacity(0.5),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // ✅ Title + Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: TextStyle(fontSize: 14, color: subTextColor, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C553B), // brand green
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // ✅ Header icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0C553B).withOpacity(0.15),
              ),
              child: const Icon(Icons.verified_user,
                  size: 60, color: Color(0xFF0C553B)),
            ),
            const SizedBox(height: 16),

            Text(
              "Effective Date: September 2025",
              style: TextStyle(
                fontSize: 14,
                color: subTextColor,
              ),
            ),
            const SizedBox(height: 24),

            // ✅ Policy sections as cards
            buildPolicyCard(
              Icons.warning_amber_rounded,
              "Information We Collect",
              "• Photos uploaded for plant identification\n"
                  "• Questions submitted through the chatbot\n"
                  "• Device and log data (model, OS, app usage)\n"
                  "• Optional feedback (surveys, testing)",
              iconColor: Colors.orange,
            ),
            buildPolicyCard(
              Icons.lock_outline,
              "How We Use Information",
              "• Identify plants using Google’s Gemini API\n"
                  "• Provide chatbot responses on herbal uses\n"
                  "• Improve accuracy and user experience\n"
                  "• Support research goals on traditional knowledge",
              iconColor: Colors.green,
            ),
            buildPolicyCard(
              Icons.share_outlined,
              "Data Sharing & Disclosure",
              "• Processed by Google’s Gemini API\n"
                  "• Aggregated data may be used for research\n"
                  "• Disclosed only if required by law",
              iconColor: Colors.blue,
            ),
            buildPolicyCard(
              Icons.security,
              "Data Storage & Security",
              "• Stored securely, accessible only to authorized members\n"
                  "• Anonymized data may be retained for research\n"
                  "• Protected against unauthorized access",
              iconColor: Colors.teal,
            ),
            buildPolicyCard(
              Icons.verified_user_outlined,
              "User Rights",
              "• Request access or deletion of data\n"
                  "• Withdraw from research anytime\n"
                  "• Decline to provide info (limits features)",
              iconColor: Colors.purple,
            ),
            buildPolicyCard(
              Icons.child_care,
              "Children’s Privacy",
              "We do not knowingly collect data from children under 13. "
              "If discovered, such data will be deleted immediately.",
              iconColor: Colors.pink,
            ),
            buildPolicyCard(
              Icons.info_outline,
              "Limitations of Use",
              "HerbaPlant is for educational and cultural purposes only. "
              "It does not provide medical advice and should not replace "
              "consultations with professionals.",
              iconColor: Colors.redAccent,
            ),
            buildPolicyCard(
              Icons.update,
              "Changes to This Policy",
              "We may update this Privacy Policy. Users will be notified "
              "of significant changes via the app or other means.",
              iconColor: Colors.indigo,
            ),
            buildPolicyCard(
              Icons.contact_mail_outlined,
              "Contact Us",
              "📧 herbaplant00@gmail.com\n",
              iconColor: Colors.cyan,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
