class WhisperModel {
  String? message;
  String? srcLang;

  WhisperModel({this.message, this.srcLang});

  WhisperModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    srcLang = json['src_lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['src_lang'] = srcLang;
    return data;
  }
}
