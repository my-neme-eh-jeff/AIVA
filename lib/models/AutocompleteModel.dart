class AutocompleteModel {
  double? score;
  int? token;
  String? tokenStr;
  String? sequence;

  AutocompleteModel({this.score, this.token, this.tokenStr, this.sequence});

  AutocompleteModel.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    token = json['token'];
    tokenStr = json['token_str'];
    sequence = json['sequence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['score'] = score;
    data['token'] = token;
    data['token_str'] = tokenStr;
    data['sequence'] = sequence;
    return data;
  }
}
