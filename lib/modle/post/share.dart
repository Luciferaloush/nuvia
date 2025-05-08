import '../auth/user.dart';

class SharedPosts {
  String? postId;
  String? content;
  List<String>? image;
  String? crcreatedAt;
  User? creator;

  SharedPosts({
    this.postId,
    this.content,
    this.image,
    this.crcreatedAt,
    this.creator,
  });

  SharedPosts.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    content = json['content'];
    image = json['image'] != null ? List<String>.from(json['image']) : null;
    crcreatedAt = json['crcreatedAt'];
    creator = json['creator'] != null ? User.fromJson(json['creator']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['postId'] = postId;
    data['content'] = content;
    data['image'] = image;
    data['crcreatedAt'] = crcreatedAt;
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    return data;
  }
}
