class Topics {
  String? message;
  List<String>? topics;

  Topics({this.message, this.topics});

  Topics.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    topics = json['topics'] != null ? List<String>.from(json['topics']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['topics'] = topics;
    return data;
  }
}
