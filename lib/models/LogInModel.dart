class LogInModel {
  String? token;
  String? accessLvl;
  String? isVerified;

  LogInModel({this.token, this.accessLvl, this.isVerified});

  LogInModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    accessLvl = json['access_lvl'];
    isVerified = json['isVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['access_lvl'] = accessLvl;
    data['isVerified'] = isVerified;
    return data;
  }
}
