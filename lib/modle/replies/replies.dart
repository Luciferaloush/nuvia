class Replies {
  String? postId;
  String? comment;
  String? firstname;
  String? lastname;

  Replies({this.postId, this.comment, this.firstname, this.lastname});

  Replies.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    comment = json['comment'];
    firstname = json['firstname'];
    lastname = json['lastname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postId'] = postId;
    data['comment'] = comment;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    return data;
  }
}
