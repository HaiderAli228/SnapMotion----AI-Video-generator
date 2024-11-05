import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

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

    if (viewModel.video != null) {
      Fluttertoast.showToast(msg: "Video generated successfully!");
    } else {
      Fluttertoast.showToast(msg: "Failed to generate video.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<VideoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image to Video Generator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImageFromGallery,
              child: const Text("Pick Image from Gallery"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _captureImage,
              child: const Text("Capture Image with Camera"),
            ),
            const SizedBox(height: 20),
            viewModel.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _generateVideo(context),
                    child: const Text("Generate Video"),
                  ),
          ],
        ),
      ),
    );
  }
}
