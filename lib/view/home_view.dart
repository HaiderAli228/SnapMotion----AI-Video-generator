import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapmotion/view/video_result_view.dart';
import 'dart:io';
import '../model-view/video_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _generateVideo(BuildContext context) async {
    if (_selectedImage == null) {
      Fluttertoast.showToast(msg: "Please select an image first!");
      return;
    }

    final viewModel = Provider.of<VideoViewModel>(context, listen: false);
    await viewModel.generateVideoFromImage(_selectedImage!);

    if (viewModel.videoFile != null) {
      Fluttertoast.showToast(msg: "Video generated successfully!");

      // Navigate to the VideoResultScreen and pass the video file and videoId
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoResultScreen(
            videoFile: viewModel.videoFile!,
            videoId: viewModel.videoId!,
          ),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "Failed to generate video.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<VideoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange,  // Assuming AppColor.themeColor
        title: const Text(
          "Image to Video Generator",
          style: TextStyle(
              color: Colors.white,  // Assuming AppColor.themeTextColor
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedImage != null)
                Image.file(
                  _selectedImage!,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                )
              else
                Container(
                  height: 300,
                  width: 300,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 100),
                ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: _captureImage,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 32,
                          color: Colors.white,
                        ),
                      )),
                  InkWell(
                    onTap: _pickImageFromGallery,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: const Text(
                        "Pick image from gallery",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              viewModel.isLoading
                  ? const CircularProgressIndicator()
                  : InkWell(
                onTap: () => _generateVideo(context),
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
                    "Generate Video",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
