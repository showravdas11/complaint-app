import 'package:complaint_app/widget/complaint_history_modal.dart';
import 'package:flutter/material.dart';
import 'package:complaint_app/screens/image_screen.dart';
import 'package:complaint_app/screens/text_complaint_screen.dart';
import 'package:complaint_app/screens/voice_screen.dart';
import 'package:complaint_app/utils/color_theme.dart';
import 'package:complaint_app/utils/text_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AskComplaint extends StatefulWidget {
  const AskComplaint({super.key});

  @override
  State<AskComplaint> createState() => _AskComplaintState();
}

class _AskComplaintState extends State<AskComplaint> {
  void _showHistoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ComplaintHistoryModal(controller: ScrollController());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColorTheme.bgColor,
        body: Stack(
          children: [
            _buildCurvedBackground(),
            _buildBubbles(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildComplaintOptions(),
                  ],
                ),
              ),
            ),
            // History button
            Positioned(
              top: 20,
              left: 20,
              child: FloatingActionButton(
                backgroundColor: MyColorTheme.bgColor,
                onPressed: () => _showHistoryModal(context), // Fixed here
                child: const Icon(Icons.history, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFD4A373), Color(0xFFFAAE42)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              "আপনি কীভাবে আপনার অভিযোগ জানাতে চান?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColorTheme.textColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: AppTextTheme.bengaliTextStyle.fontFamily,
              ),
            ),
          ),
          const SizedBox(height: 35),
          ComplaintOption(
            icon: Icons.email_rounded,
            label: "টেক্সট মেসেজের মাধ্যমে",
            colors: const [Color(0xFFD4A373), Color(0xFFFAAE42)],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TextComplaintScreen()),
              );
            },
          ),
          const SizedBox(height: 20),
          ComplaintOption(
            icon: Icons.mic,
            label: "ভয়েস মেসেজের মাধ্যমে",
            colors: const [Color(0xFF6DAA6A), Color(0xFF4C744C)],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VoiceScreen()),
              );
            },
          ),
          const SizedBox(height: 20),
          ComplaintOption(
            icon: Icons.image,
            label: "ছবি পাঠানোর মাধ্যমে",
            colors: const [Color(0xFF7092B0), Color(0xFFA7C0DB)],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageSubmissionScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurvedBackground() {
    return ClipPath(
      clipper: CustomWaveClipper(),
      child: Container(
        color: const Color(0xFF304D25),
        height: MediaQuery.of(context).size.height * 0.3,
      ),
    );
  }

  Widget _buildBubbles() {
    return Stack(
      children: [
        Positioned(left: 50, top: 100, child: _bubble()),
        Positioned(right: 30, top: 230, child: _bubble()),
        Positioned(left: 150, bottom: 150, child: _bubble()),
        Positioned(right: 100, bottom: 80, child: _bubble()),
      ],
    );
  }

  Widget _bubble() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: MyColorTheme.textColor.withOpacity(0.1),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
    );
  }
}

class ComplaintOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> colors;
  final VoidCallback onPressed;

  const ComplaintOption({
    required this.icon,
    required this.label,
    required this.colors,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: colors),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyColorTheme.textColor.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: MyColorTheme.textColor, size: 28),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color: MyColorTheme.textColor,
                fontFamily: AppTextTheme.bengaliTextStyle.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Wave Clip for Background
class CustomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 40);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height - 80, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
