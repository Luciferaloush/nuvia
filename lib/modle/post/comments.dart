class Comments {
  String? userId;
  String? comment;
  String? sId;
  String? createdAt;

  Comments({this.userId, this.comment, this.sId, this.createdAt});

  Comments.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    comment = json['comment'];
    sId = json['_id'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['comment'] = comment;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    return data;
  }
}
