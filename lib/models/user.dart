import 'dart:convert';

class UserModel {
  final String name;
  final String avatar;
  final String email;
  final String phoneNumber;
  final String theme;
  final String background;

  const UserModel(this.name, this.avatar, this.email, this.phoneNumber,
      this.theme, this.background);

  static UserModel fromResponseMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return UserModel(
        map['builder']['builderName'],
        map['settings']['avatar'],
        map['builder']['email'],
        map['builder']['phone'],
        map['settings']['theme'],
        map['settings']['background']);
  }

  static UserModel fromJsonResponse(String source) =>
      fromResponseMap(json.decode(source)['result']);
}