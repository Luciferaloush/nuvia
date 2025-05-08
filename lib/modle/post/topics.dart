class Topics {
  List<String>? ar;
  List<String>? en;

  Topics({this.ar, this.en});

  Topics.fromJson(Map<String, dynamic> json) {
    ar = json['ar'].cast<String>();
    en = json['en'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ar'] = ar;
    data['en'] = en;
    return data;
  }
}