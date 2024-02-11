import 'dart:convert';

UserLivestreamTokenModel userLivestreamTokenModelFromJson(String str) =>
    UserLivestreamTokenModel.fromJson(json.decode(str));

String userLivestreamTokenModelToJson(UserLivestreamTokenModel data) =>
    json.encode(data.toJson());

class UserLivestreamTokenModel {
  final String? id;
  final String? token;

  UserLivestreamTokenModel({
    this.id,
    this.token,
  });

  UserLivestreamTokenModel copyWith({
    String? id,
    String? token,
  }) =>
      UserLivestreamTokenModel(
        id: id ?? this.id,
        token: token ?? this.token,
      );

  factory UserLivestreamTokenModel.fromJson(Map<String, dynamic> json) =>
      UserLivestreamTokenModel(
        id: json["id"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
      };
}
