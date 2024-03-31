class IdentifyUserModel {
  bool? success;
  String? name;

  IdentifyUserModel({this.success, this.name});

  IdentifyUserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['name'] = this.name;
    return data;
  }
}
