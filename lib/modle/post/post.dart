import 'package:nuvia/modle/auth/user.dart';

import '../topic/topics.dart';
import 'comments.dart';

class Posts {
  Topics? topics;
  List<String>? hashtage;
  String? sId;
  String? content;
  List<String>? image;
  User? creator;
  String? createdAt;
  int? iV;
  List<Comments>? comments;
  List<String>? likes;
  List<String>? sharedPosts;
  bool? likeStatus;


  Posts(
      {this.topics,
        this.hashtage,
        this.sId,
        this.content,
        this.image,
        this.creator,
        this.createdAt,
        this.iV,
        this.comments,
        this.likes,
        this.sharedPosts});

  Posts.fromJson(Map<String, dynamic> json) {
    print("Json: $json");
    topics = json['topics'] != null ? Topics.fromJson(json['topics']) : null;
    hashtage = json['hashtage']?.map<String>((v) => v.toString()).toList() ?? [];
    sId = json['_id'];
    content = json['content'];
    image = json['image']?.cast<String>() ?? [];
    creator = json['creator'] != null ? User.fromJson(json['creator']) : null;
    createdAt = json['createdAt'];
    iV = json['__v'];
    comments = json['comments'] != null
        ? (json['comments'] as List).map((v) => Comments.fromJson(v)).toList()
        : [];
    likes = json['likes']?.cast<String>() ?? [];
    sharedPosts = json['sharedPosts']?.cast<String>() ?? [];
    likeStatus = json['likeStatus'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (topics != null) {
      data['topics'] = topics!.toJson();
    }
    if (hashtage != null) {
      data['hashtage'] = hashtage!;
    }
    data['_id'] = sId;
    data['content'] = content;
    data['image'] = image;
    data['creator'] = creator?.toJson();
    data['createdAt'] = createdAt;
    data['__v'] = iV;
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    data['likes'] = likes;
    data['sharedPosts'] = sharedPosts;
    data['likeStatus'] = likeStatus;
    return data;
  }
}
