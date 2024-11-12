import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

class ComplaintHistoryModal extends StatefulWidget {
  final ScrollController controller;

  ComplaintHistoryModal({Key? key, required this.controller}) : super(key: key);

  @override
  _ComplaintHistoryModalState createState() => _ComplaintHistoryModalState();
}

class _ComplaintHistoryModalState extends State<ComplaintHistoryModal> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool _isPlayingAudio = false;
  String? currentlyPlayingAudio;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Complaint History",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(color: Colors.grey.withOpacity(0.5)),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('complaint')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No complaints found."));
                  }

                  final complaints = snapshot.data!.docs;

                  return ListView.builder(
                    controller: controller,
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      var complaintData =
                          complaints[index].data() as Map<String, dynamic>;
                      return _buildHistoryItem(index + 1, complaintData);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(int index, Map<String, dynamic> complaintData) {
    String complaintStatus = complaintData['status'] ?? 'Pending';
    String complaintTitle = complaintData['title'] ?? 'Complaint';
    String complaintText = complaintData['complaintText'] ?? '';
    String? imageUrl = complaintData['imageUrl'];
    String? audioUrl = complaintData['audioUrl'];

    // Define alignment based on whether it's a default message
    bool isDefaultMessage = complaintData['isDefault'] ?? false;
    Alignment alignment =
        isDefaultMessage ? Alignment.centerRight : Alignment.centerLeft;
    Color bubbleColor =
        isDefaultMessage ? Colors.green.shade100 : Colors.blue.shade50;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft:
                  isDefaultMessage ? Radius.circular(20) : Radius.circular(0),
              bottomRight:
                  isDefaultMessage ? Radius.circular(0) : Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Status Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "$complaintTitle #$index",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: complaintStatus == 'Resolved'
                          ? Colors.green
                          : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      complaintStatus,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Complaint Text Section
              if (complaintText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    complaintText,
                    style: TextStyle(
                        fontSize: 14, color: Colors.black.withOpacity(0.7)),
                  ),
                ),

              // Image Display with Full-Screen Viewer
              if (imageUrl != null)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImage(imageUrl: imageUrl),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

              // Audio Section with Play Button
              if (audioUrl != null)
                GestureDetector(
                  onTap: () => _playAudio(audioUrl),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isPlayingAudio && currentlyPlayingAudio == audioUrl
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isPlayingAudio && currentlyPlayingAudio == audioUrl
                              ? "Pause Audio"
                              : "Play Audio",
                          style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
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
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
