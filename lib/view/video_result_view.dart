import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoResultScreen extends StatefulWidget {
  final File videoFile;
  final String videoId;

  const VideoResultScreen(
      {super.key, required this.videoFile, required this.videoId});

  @override
  _VideoResultScreenState createState() => _VideoResultScreenState();
}

class _VideoResultScreenState extends State<VideoResultScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Initialize the VideoPlayerController with the video file
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Result"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Video ID: ${widget.videoId}'),
            const SizedBox(height: 20),
            _controller.value.isInitialized
                ? Column(
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (_isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                            _isPlaying = !_isPlaying;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 307,
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Text(
                            "Download Video",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
