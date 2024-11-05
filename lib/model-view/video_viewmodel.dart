import 'dart:io';
import 'package:flutter/material.dart';

import '../model/video_model.dart';
import '../services/api_services.dart';


class VideoViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  VideoModel? video;
  bool isLoading = false;

  Future<void> generateVideoFromImage(File imageFile) async {
    isLoading = true;
    notifyListeners();

    video = await _apiService.uploadImage(imageFile);

    isLoading = false;
    notifyListeners();
  }
}
