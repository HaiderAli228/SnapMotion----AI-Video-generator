import 'dart:io';
import 'package:flutter/foundation.dart';

import '../model/video_model.dart';

class VideoViewModel extends ChangeNotifier {
  final VideoModel _videoModel = VideoModel();
  String? video;
  bool isLoading = false;

  Future<void> generateVideoFromImage(File imageFile) async {
    isLoading = true;
    notifyListeners();

    video = await _videoModel.uploadImageForVideo(imageFile);

    isLoading = false;
    notifyListeners();
  }
}
