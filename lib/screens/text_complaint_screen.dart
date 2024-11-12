import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_app/utils/color_theme.dart';
import 'package:complaint_app/utils/text_theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:file_picker/file_picker.dart';

class TextComplaintScreen extends StatelessWidget {
  TextComplaintScreen({super.key});
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String?> _selectedFileName = ValueNotifier(null);

  Future<void> submitComplaint(BuildContext context) async {
    String complaintText = _controller.text;
    OverlayState? overlayState = Overlay.of(context);

    // -------------------------Check if both text and file are empty--------------------------------
    if (complaintText.isEmpty && _selectedFileName.value == null) {
      showTopSnackBar(
        overlayState!,
        CustomSnackBar.error(
          message: "দয়া করে একটি অভিযোগ লিখুন অথবা একটি ফাইল সংযুক্ত করুন।",
        ),
      );
      return;
    }

    CollectionReference complaints =
        FirebaseFirestore.instance.collection('complaint');

    String? fileUrl;

    // --------------------------------Upload the selected file if it exists-------------------------------
    if (_selectedFileName.value != null) {
      final filePath = _selectedFileName.value;
      final file = File(filePath!);
      final fileName = file.uri.pathSegments.last;

      // ------------------Upload to Firebase Storage-----------------------------
      Reference storageRef =
          FirebaseStorage.instance.ref().child('complaints/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      fileUrl = await snapshot.ref.getDownloadURL();
    }

    await complaints.add({
      'complaintText': complaintText.isNotEmpty ? complaintText : null,
      'fileUrl': fileUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();
    _selectedFileName.value = null;
    showTopSnackBar(
      overlayState!,
      CustomSnackBar.success(
        message: "আপনার অভিযোগটি সফলভাবে জমা হয়েছে। ধন্যবাদ।",
      ),
    );
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
                  _buildTextInput(),
                  const SizedBox(height: 20),
                  FileSelector(selectedFileName: _selectedFileName),
                  const SizedBox(height: 30),
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
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
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
    );
  }
}

class FileSelector extends StatelessWidget {
  final ValueNotifier<String?> selectedFileName;

  FileSelector({required this.selectedFileName});

Future<void> _pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowedExtensions: ['pdf', 'doc', 'docx', 'zip'],
    type: FileType.custom,
  );

  if (result != null) {
    selectedFileName.value = result.files.first.path;
  }
}


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedFileName,
      builder: (context, fileName, _) {
        return Column(
          children: [
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
                onPressed: _pickFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: Text(
                  fileName == null
                      ? "ফাইল নির্বাচন করুন"
                      : "নতুন ফাইল নির্বাচন করুন",
                  style: TextStyle(
                    fontFamily: AppTextTheme.bengaliTextStyle.fontFamily,
                    color: MyColorTheme.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (fileName != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "নির্বাচিত ফাইল: ${fileName.split('/').last}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          ],
        );
      },
    );
  }
}
