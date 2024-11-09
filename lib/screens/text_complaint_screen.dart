import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_app/utils/color_theme.dart';
import 'package:complaint_app/utils/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TextComplaintScreen extends StatelessWidget {
  TextComplaintScreen({super.key});
  final TextEditingController _controller = TextEditingController();

  // ------------------------------------ data store in firebase -------------------------------------

  void submitComplaint(BuildContext context) async {
    String complaintText = _controller.text;
    OverlayState? overlayState = Overlay.of(context);

    if (complaintText.isNotEmpty) {
      CollectionReference complaints =
          FirebaseFirestore.instance.collection('complaint');

      try {
        await complaints.add({
          'complaintText': complaintText,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _controller.clear();
        if (overlayState != null) {
          showTopSnackBar(
            overlayState,
            CustomSnackBar.success(
              maxLines: 3,
              message:
                  "আপনার অভিযোগটি সফলভাবে জমা হয়েছে। আমরা শীঘ্রই এ বিষয়ে আপনাকে জানাব। ধন্যবাদ।",
            ),
          );
        }
      } catch (e) {
        print("Failed to submit complaint: $e");
      }
    } else {
      if (overlayState != null) {
        showTopSnackBar(
          overlayState,
          CustomSnackBar.error(
            message: "জমা দেওয়ার আগে দয়া করে আপনার অভিযোগটি লিখুন।",
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2A4320), Color(0xFF1B2E16)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "আপনার অভিযোগ লিখুন",
                    style: TextStyle(
                      fontSize: 26,
                      color: const Color(0xFFD4A373),
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTextTheme.bengaliTextStyle.fontFamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: MyColorTheme.textColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: MyColorTheme.textColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          MyColorTheme.textColor.withOpacity(0.1),
                          MyColorTheme.textColor.withOpacity(0.05)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: 6,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "আপনার অভিযোগ এখানে লিখুন...",
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontFamily: AppTextTheme.bengaliTextStyle.fontFamily,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6DAA6A), Color(0xFF4C744C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      onPressed: () => submitComplaint(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                      child: Text(
                        "জমা দিন",
                        style: TextStyle(
                          color: MyColorTheme.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTextTheme.bengaliTextStyle.fontFamily,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
