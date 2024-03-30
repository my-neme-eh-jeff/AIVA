class SignUpModel {
  String? message;
  User? user;

  SignUpModel({this.message, this.user});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? fname;
  String? lname;
  String? email;
  String? password;

  User({this.fname, this.lname, this.email, this.password});

  User.fromJson(Map<String, dynamic> json) {
    fname = json['fname'];
    lname = json['lname'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fname'] = fname;
    data['lname'] = lname;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
