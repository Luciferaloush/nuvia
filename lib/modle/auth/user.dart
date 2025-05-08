class User {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  int? gender;
  String? image;
  List<String>? selectedTopics;

  User(
      {this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.gender,
      this.image,
      this.selectedTopics});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    gender = json['gender'];
    image = json['image'];
    selectedTopics = json['selectedTopics'] != null
        ? List<String>.from(json['selectedTopics'])
        : [];  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['gender'] = gender;
    data['image'] = image;
    data['selectedTopics'] = selectedTopics;
    return data;
  }
}
