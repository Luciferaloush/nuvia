import 'my_replies.dart';
import 'post_owner.dart';
import 'replies.dart';

class MyComments {
  Replies? replies;
  PostOwner? postOwner;
  String? createdAt;

  MyComments({this.replies, this.postOwner, this.createdAt});

  MyComments.fromJson(Map<String, dynamic> json) {
    replies =
        json['replies'] != null ? Replies.fromJson(json['replies']) : null;
    postOwner = json['postOwner'] != null
        ? PostOwner.fromJson(json['postOwner'])
        : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (replies != null) {
      data['replies'] = replies!.toJson();
    }
    if (postOwner != null) {
      data['postOwner'] = postOwner!.toJson();
    }
    data['createdAt'] = createdAt;
    return data;
  }
}
