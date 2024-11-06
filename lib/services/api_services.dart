import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:snapmotion/utils/links.dart';

import '../model/video_model.dart';


class ApiService {
  Future<VideoModel?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse(Links.endPoint);
      var request = http.MultipartRequest('POST', url)
        ..headers['authorization'] = 'Bearer ${Link}'
        ..fields['seed'] = '0'
        ..fields['cfg_scale'] = '1.8'
        ..fields['motion_bucket_id'] = '127'
        ..files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = jsonDecode(responseData.body);
        return VideoModel.fromJson(data);
      } else {
        print("Failed to upload image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception during upload: $e");
      return null;
    }
  }
}
