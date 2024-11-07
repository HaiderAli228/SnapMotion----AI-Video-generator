import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../model-view/video_viewmodel.dart';

class VideoResultScreen extends StatelessWidget {
  final String videoId;

  const VideoResultScreen({super.key, required this.videoId});

  Future<void> _downloadVideo(String videoId) async {
    final url = "https://yourvideourl.com/video/$videoId"; // Actual URL for the video
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/$videoId.mp4";

    try {
      await Dio().download(url, path);
      Fluttertoast.showToast(msg: "Video downloaded to $path");
    } catch (e) {
      Fluttertoast.showToast(msg: "Download failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<VideoViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Generated Video"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (viewModel.videoUrl != null)
            // Display the video or a placeholder image for the video
              Image.network(viewModel.videoUrl!)
            else
              const CircularProgressIndicator(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _downloadVideo(videoId),
              icon: const Icon(Icons.download),
              label: const Text("Download Video"),
            ),
          ],
        ),
      ),
    );
  }
}
