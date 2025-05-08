import 'my_comments.dart';

class MyReplies {
  String? userId;
  List<MyComments>? comments;
  int? totalComments;

  MyReplies({this.userId, this.comments, this.totalComments});

  MyReplies.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    if (json['comments'] != null) {
      comments = <MyComments>[];
      json['comments'].forEach((v) {
        comments!.add(MyComments.fromJson(v));
      });
    }
    totalComments = json['totalComments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    data['totalComments'] = totalComments;
    return data;
  }
}
