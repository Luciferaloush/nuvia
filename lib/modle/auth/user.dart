import '../../core/constants/app_constants.dart';
import '../post/post.dart';

class User {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  int? gender;
  String? image;
  List<String>? selectedTopics;
  int? followers;
  int? following;
  int? followingStatus;
  List<Posts>? pots;
  String? followingStatusFo;

  User(
      {this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.gender,
      this.image,
      this.selectedTopics,
      this.followingStatusFo});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    gender = json['gender'];
    image = json['image'];
    selectedTopics = json['selectedTopics'] != null
        ? List<String>.from(json['selectedTopics'])
        : (json['topics'] != null ? List<String>.from(json['topics']) : []);

    followers = json['followers'] is int ? json['followers'] : null;
    following = json['following'] is int ? json['following'] : null;
    followingStatus =
        json['followingStatus'] is int ? json['followingStatus'] : null;

    if (json['pots'] != null) {
      pots = <Posts>[];
      for (var v in json['pots']) {
        if (v is Map<String, dynamic>) {
          pots!.add(Posts.fromJson(v,
             AppConstants.userId
          ));
        } else {
          print('Expected Map but got String: $v');
        }
      }
    }
    followingStatusFo = json['followingStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['gender'] = gender;
    data['image'] = image;
    data['selectedTopics'] = selectedTopics;
    data['followers'] = followers;
    data['following'] = following;
    data['followingStatus'] = followingStatus;
    if (pots != null) {
      data['posts'] = pots!.map((v) => v.toJson()).toList();
    }
    data['followingStatus'] = followingStatusFo;
    return data;
  }
}
