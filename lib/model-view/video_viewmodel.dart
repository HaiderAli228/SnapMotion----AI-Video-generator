import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/video_model.dart';

class VideoViewModel extends ChangeNotifier {
  VideoViewModel();

  final VideoModel _videoModel = VideoModel();
  File? videoFile;
  String? videoId;  // Store the video generation ID
  bool isLoading = false;

  Future<void> generateVideoFromImage(File imageFile) async {
    isLoading = true;
    notifyListeners();

    try {
      // Initiate video generation and store generation ID in videoId
      videoId = await _videoModel.uploadImageForVideo(imageFile);

      if (videoId != null) {
        // Poll the API and download the video when ready
        videoFile = await _videoModel.fetchAndDownloadVideo(videoId!);
        if (videoFile != null) {
          Fluttertoast.showToast(msg: "Video generated successfully!");
        } else {
          Fluttertoast.showToast(msg: "Failed to generate video.");
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to generate video.");
      }
    } catch (e) {
      videoFile = null;
      Fluttertoast.showToast(msg: "An error occurred: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
