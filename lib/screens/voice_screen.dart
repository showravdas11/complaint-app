import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_app/utils/text_theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3_plus/record_mp3_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  _VoiceScreenState createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen>
    with SingleTickerProviderStateMixin {
  bool isRecording = false;
  bool _isUploading = false;
  bool _isPlayingAudio = false;
  double _uploadProgress = 0.0;
  String? audioPath;
  String? audioUrl;
  String? currentlyPlayingAudio;
  final AudioPlayer audioPlayer = AudioPlayer();
  late AnimationController _animationController;

  bool get isSubmitEnabled => audioUrl != null && !isRecording;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    if (isRecording) {
      stopRecord();
    } else {
      startRecord();
    }
    setState(() => isRecording = !isRecording);
  }

  Future<void> startRecord() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return;
    }
    Directory tempDir = await getTemporaryDirectory();
    audioPath =
        '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
    RecordMp3.instance.start(audioPath!, (type) {});
    _animationController.repeat(reverse: true);
  }

  Future<void> stopRecord() async {
    if (isRecording) {
      bool result = RecordMp3.instance.stop();
      if (result) {
        _animationController.stop();
      }
      setState(() {
        audioUrl = audioPath;
      });
    }
  }

  Future<void> _uploadAudio() async {
    if (audioPath == null) return;
    setState(() => _isUploading = true);

    final audioFile = File(audioPath!);
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('complaintAudio/${DateTime.now().millisecondsSinceEpoch}.mp3');
    final uploadTask = storageRef.putFile(audioFile);

    uploadTask.snapshotEvents.listen((event) {
      setState(
          () => _uploadProgress = event.bytesTransferred / event.totalBytes);
    });
    audioUrl = await (await uploadTask).ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('complaint').add({
      'audioUrl': audioUrl,
    });

    setState(() {
      _isUploading = false;
    });

    showTopSnackBar(
      Overlay.of(context),
      const CustomSnackBar.success(
        message: "আপনার অডিওটি সফলভাবে জমা হয়েছে। ধন্যবাদ।",
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  void _playAudio(String url) async {
    if (_isPlayingAudio && currentlyPlayingAudio == url) {
      await audioPlayer.pause();
      setState(() {
        _isPlayingAudio = false;
      });
    } else if (!_isPlayingAudio && currentlyPlayingAudio == url) {
      await audioPlayer.resume();
      setState(() {
        _isPlayingAudio = true;
      });
    } else {
      await audioPlayer.stop();
      setState(() {
        _isPlayingAudio = true;
        currentlyPlayingAudio = url;
      });
      await audioPlayer.play(UrlSource(url));
    }
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlayingAudio = false;
        currentlyPlayingAudio = null;
      });
    });
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("অডিওটি ডিলিট করুন"),
          content: const Text("আপনি কি এই অডিওটি মুছে ফেলতে চান?"),
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
                _deleteAudio();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAudio() {
    if (audioPath != null) {
      File(audioPath!).delete();
      setState(() {
        audioUrl = null;
        audioPath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A4320), Color(0xFF1B2E16)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ভয়েস রেকর্ড করুন",
                style: TextStyle(
                  fontSize: 26,
                  color: const Color(0xFFD4A373),
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTextTheme.bengaliTextStyle.fontFamily,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _toggleRecording,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      width: 140 + _animationController.value * 20,
                      height: 140 + _animationController.value * 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isRecording
                              ? [Color(0xFFFF6B6B), Color(0xFFFF3B3B)]
                              : [Color(0xFF6DAA6A), Color(0xFF4C744C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isRecording
                                ? Colors.red.withOpacity(0.6)
                                : Colors.green.withOpacity(0.6),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          isRecording ? Icons.stop : Icons.mic,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      isRecording
                          ? "রেকর্ডিং চলছে..."
                          : "রেকর্ডিং শুরু করতে মাইক্রোফোনে চাপুন",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: AppTextTheme.bengaliTextStyle.fontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Icon(
                      isRecording ? Icons.record_voice_over : Icons.mic,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (audioUrl != null) ...[
                GestureDetector(
                  onTap: () => _playAudio(audioUrl!),
                  child: Container(
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6DAA6A), Color(0xFF4C744C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_arrow, color: Colors.white),
                          const SizedBox(width: 10),
                          Text("অডিওটি শুনুন",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily:
                                    AppTextTheme.bengaliTextStyle.fontFamily,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _showDeleteConfirmationDialog,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(171, 255, 78, 81),
                            Color.fromARGB(167, 215, 38, 62)
                          ],
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
                            Text("আপনার অডিওটি ডিলিট করুন",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily:
                                      AppTextTheme.bengaliTextStyle.fontFamily,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: isSubmitEnabled ? _uploadAudio : null,
                  child: Container(
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6DAA6A), Color(0xFF4C744C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: _isUploading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                value: null,
                                strokeWidth: 2,
                              ),
                            )
                          : Text("জমা দিন",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily:
                                    AppTextTheme.bengaliTextStyle.fontFamily,
                              )),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
