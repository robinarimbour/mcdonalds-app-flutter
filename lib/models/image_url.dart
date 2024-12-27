class ImageUrl {
  String? sId;
  int? id;
  String? name;
  String? url;

  ImageUrl({this.sId, this.id, this.name, this.url});

  ImageUrl.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['id'] = id;
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}
