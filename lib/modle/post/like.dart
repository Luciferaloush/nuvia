import '../auth/user.dart';

class Like {
  String? postId;
  List<User>? likes;
  int? totalLikes;

  Like({this.postId, this.likes, this.totalLikes});

  Like.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    if (json['likes'] != null) {
      likes = <User>[];
      json['likes'].forEach((v) {
        likes!.add(User.fromJson(v));
      });
    }
    totalLikes = json['totalLikes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postId'] = postId;
    if (likes != null) {
      data['likes'] = likes!.map((v) => v.toJson()).toList();
    }
    data['totalLikes'] = totalLikes;
    return data;
  }
}
class NumLikes {
  int? likes;

  NumLikes({this.likes});

  NumLikes.fromJson(Map<String, dynamic> json) {
    likes = json['likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['likes'] = likes;
    return data;
  }
}
