class PostOwner {
  String? content;
  String? image;
  String? firstname;
  String? lastname;

  PostOwner({this.content, this.image, this.firstname, this.lastname});

  PostOwner.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    //image = json['image']?.cast<String>() ?? [];
    image = json['image'] != null && json['image'] is List
        ? (json['image'] as List).isNotEmpty ? json['image'][0] : null
        : json['image'];
    //image = json['image'];
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
