import 'dart:io';
import 'package:flutter/foundation.dart';
import '../model/video_model.dart';

class VideoViewModel extends ChangeNotifier {
  final VideoModel _videoModel = VideoModel();
  String? video; // Video ID
  String? videoUrl; // Video URL for display
  bool isLoading = false;

  Future<void> generateVideoFromImage(File imageFile) async {
    isLoading = true;
    notifyListeners();

    video = await _videoModel.uploadImageForVideo(imageFile);

    if (video != null) {
      videoUrl = "https://yourvideourl.com/video/$video"; // Replace with actual video URL
    } else {
      videoUrl = null;
    }

    isLoading = false;
    notifyListeners();
  }
}
