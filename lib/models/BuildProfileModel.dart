class BuildProfileModel {
  bool? success;
  Data? data;

  BuildProfileModel({this.success, this.data});

  BuildProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Child? child;

  Data({this.child});

  Data.fromJson(Map<String, dynamic> json) {
    child = json['child'] != null ? Child.fromJson(json['child']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (child != null) {
      data['child'] = child!.toJson();
    }
    return data;
  }
}

class Child {
  String? parent;
  String? name;
  String? audioFile;
  String? sId;
  int? iV;

  Child({this.parent, this.name, this.audioFile, this.sId, this.iV});

  Child.fromJson(Map<String, dynamic> json) {
    parent = json['parent'];
    name = json['name'];
    audioFile = json['audioFile'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parent'] = parent;
    data['name'] = name;
    data['audioFile'] = audioFile;
    data['_id'] = sId;
    data['__v'] = iV;
    return data;
  }
}
