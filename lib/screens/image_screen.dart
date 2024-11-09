import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_app/utils/color_theme.dart';
import 'package:complaint_app/utils/text_theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ImageSubmissionScreen extends StatefulWidget {
  const ImageSubmissionScreen({super.key});

  @override
  State<ImageSubmissionScreen> createState() => _ImageSubmissionScreenState();
}

class _ImageSubmissionScreenState extends State<ImageSubmissionScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
    Navigator.of(context).pop();
  }

  Future<void> _submitImage() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);
    final imageFile = File(_selectedImage!.path);
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('complaintImages/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putFile(imageFile);

    uploadTask.snapshotEvents.listen((event) {
      setState(
          () => _uploadProgress = event.bytesTransferred / event.totalBytes);
    });

    final imageUrl = await (await uploadTask).ref.getDownloadURL();
    FirebaseFirestore.instance.collection('complaint').add({
      'imageUrl': imageUrl,
    });

    setState(() {
      _isUploading = false;
      _selectedImage = null;
    });

    showTopSnackBar(
      Overlay.of(context),
      Material(
        color: Colors.greenAccent,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "আপনার ছবিটি সফলভাবে জমা হয়েছে। ধন্যবাদ।",
            style: TextStyle(
              color: MyColorTheme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: AppTextTheme.bengaliTextStyle.fontFamily,
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF6DAA6A), const Color(0xFF4C744C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: MyColorTheme.textColor,
                ),
                title: Text("আপনার গ্যালারি থেকে ছবি বাচাই করুন",
                    style: TextStyle(
                      color: MyColorTheme.textColor,
                      fontFamily: AppTextTheme.bengaliTextStyle.fontFamily,
                    )),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: MyColorTheme.textColor,
                ),
                title: Text("ক্যামেরা দিয়ে ছবি তুলুন",
                    style: TextStyle(
                      color: MyColorTheme.textColor,
                      fontFamily: AppTextTheme.bengaliTextStyle.fontFamily,
                    )),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("ছবিটি ডিলিট করুন"),
          content: const Text("আপনি কি এই ছবিটি মুছে ফেলতে চান?"),
          actions: <Widget>[
            TextButton(
              child: const Text("না"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("হ্যাঁ"),
              onPressed: () {
                _deleteImage();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteImage() {
    if (_selectedImage != null) {
      setState(() {
        _selectedImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColorTheme.bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "অপনার ছবিটি সাবমিট করুন",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFD4A373),
                fontFamily: AppTextTheme.bengaliTextStyle.fontFamily,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6DAA6A),
                      const Color(0xFF4C744C),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: _selectedImage == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo,
                                color: MyColorTheme.textColor, size: 60),
                            const SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                textAlign: TextAlign.center,
                                "ছবি সিলেক্ট করার জন্য এইখানে ক্লিক করুন",
                                style: TextStyle(
                                  color:
                                      MyColorTheme.textColor.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily:
                                      AppTextTheme.bengaliTextStyle.fontFamily,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap:
                  _selectedImage != null && !_isUploading ? _submitImage : null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: _selectedImage != null
                      ? const LinearGradient(
                          colors: [Color(0xFF6DAA6A), Color(0xFF4C744C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [Colors.grey, Colors.grey],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: _isUploading
                    ? CircularProgressIndicator(
                        value: _uploadProgress,
                        color: Colors.white,
                      )
                    : Text(
                        "ছবি জমা দিন",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: AppTextTheme.bengaliTextStyle.fontFamily,
                          color: MyColorTheme.textColor,
                        ),
                      ),
              ),
            ),

            // delete btn

            const SizedBox(height: 15),
            // delete button
            GestureDetector(
              onTap:
                  _selectedImage != null ? _showDeleteConfirmationDialog : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: _selectedImage != null
                        ? const LinearGradient(
                            colors: [
                              Color.fromARGB(171, 255, 78, 81),
                              Color.fromARGB(167, 215, 38, 62)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : const LinearGradient(
                            colors: [Colors.grey, Colors.grey],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.delete, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          "আপনার ছবিটি ডিলিট করুন",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily:
                                AppTextTheme.bengaliTextStyle.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
