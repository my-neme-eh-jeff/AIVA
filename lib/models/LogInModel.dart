class LogInModel {
  bool? success;
  Data? data;

  LogInModel({this.success, this.data});

  LogInModel.fromJson(Map<String, dynamic> json) {
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
  String? token;
  String? accessLvl;
  bool? isVerified;
  bool? login;

  Data({this.token, this.accessLvl, this.isVerified, this.login});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    accessLvl = json['access_lvl'];
    isVerified = json['isVerified'];
    login = json['login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['access_lvl'] = accessLvl;
    data['isVerified'] = isVerified;
    data['login'] = login;
    return data;
  }
}
