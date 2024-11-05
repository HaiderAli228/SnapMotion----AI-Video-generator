class VideoModel {
  final String id;

  VideoModel({required this.id});

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(id: json['id']);
  }
}
