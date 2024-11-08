import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../utils/links.dart';

class VideoModel {
  // Resize the image to meet API requirements
  Future<File> resizeImage(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image != null) {
      // Resize to 768x768 (change dimensions as needed)
      final resizedImage = img.copyResize(image, width: 768, height: 768);

      // Save the resized image in a unique location to avoid overwriting the original image
      final directory = await getApplicationDocumentsDirectory();
      final resizedImagePath = "${directory.path}/resized_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final resizedImageFile = File(resizedImagePath)
        ..writeAsBytesSync(img.encodeJpg(resizedImage));

      return resizedImageFile;
    } else {
      throw Exception("Unable to decode image");
    }
  }

  // Upload the image to generate a video and return the generation ID
  Future<String?> uploadImageForVideo(File imageFile) async {
    try {
      final resizedImageFile = await resizeImage(imageFile);
      final url = Uri.parse(Links.endPoint);
      var request = http.MultipartRequest('POST', url)
        ..headers['authorization'] = 'Bearer ${Links.apiKey}'
        ..files.add(await http.MultipartFile.fromPath('image', resizedImageFile.path))
        ..fields['seed'] = '0'
        ..fields['cfg_scale'] = '1.8'
        ..fields['motion_bucket_id'] = '127';

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = jsonDecode(responseData.body);
        return data['id']; // generation_id
      } else {
        final errorResponse = await http.Response.fromStream(response);
        print("Error response: ${errorResponse.body}");
        return null;
      }
    } catch (e) {
      print("Error during image upload: $e");
      return null;
    }
  }

  // Poll the API to check if the video is ready and download it
  Future<File?> fetchAndDownloadVideo(String generationId) async {
    final url = Uri.parse('${Links.endPoint}/result/$generationId');
    final headers = {
      'authorization': 'Bearer ${Links.apiKey}',
      'accept': 'video/*',
    };

    int retryCount = 0;
    const int maxRetries = 10;

    while (retryCount < maxRetries) {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        // Save the video file locally
        final directory = await getApplicationDocumentsDirectory();
        final path = "${directory.path}/$generationId.mp4";
        final file = File(path);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else if (response.statusCode == 202) {
        // Video is still being generated; wait and retry
        retryCount++;
        await Future.delayed(const Duration(seconds: 10));
      } else {
        final data = jsonDecode(response.body);
        print("Error fetching video: ${data}");
        return null;
      }
    }
    print("Max retries reached, video not ready.");
    return null; // Return null if max retries are reached
  }
}
