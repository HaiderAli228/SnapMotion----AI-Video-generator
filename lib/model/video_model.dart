import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../utils/links.dart';

class VideoModel {
  Future<String?> uploadImageForVideo(File imageFile) async {
    final url = Uri.parse(Links.endPoint);

    var request = http.MultipartRequest('POST', url)
      ..headers['authorization'] = 'Bearer ${Links.apiKey}'
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
      return data['id'];
    } else {
      return null;
    }
  }
}
