// // video_model.dart
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// class VideoModel {
//   Future<String?> uploadImageForVideo(File imageFile) async {
//     final url = Uri.parse("https://api.stability.ai/v2beta/image-to-video");
//     const apiKey = "sk-YOURAPIKEY"; // Replace with your actual API key
//
//     var request = http.MultipartRequest('POST', url)
//       ..headers['authorization'] = 'Bearer $apiKey'
//       ..fields['seed'] = '0'
//       ..fields['cfg_scale'] = '1.8'
//       ..fields['motion_bucket_id'] = '127'
//       ..files.add(await http.MultipartFile.fromPath(
//         'image',
//         imageFile.path,
//       ));
//
//     var response = await request.send();
//
//     if (response.statusCode == 200) {
//       final responseData = await http.Response.fromStream(response);
//       final data = jsonDecode(responseData.body);
//       return data['id'];
//     } else {
//       return null;
//     }
//   }
// }
