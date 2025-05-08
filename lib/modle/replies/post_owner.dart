class PostOwner {
  String? content;
  Null? image;
  String? firstname;
  String? lastname;

  PostOwner({this.content, this.image, this.firstname, this.lastname});

  PostOwner.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    image = json['image'];
    firstname = json['firstname'];
    lastname = json['lastname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['image'] = image;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    return data;
  }
}
