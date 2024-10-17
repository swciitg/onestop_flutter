import 'dart:convert';

class Admin {
  String id;
  String outlookEmail;
  String board;
  String position;
  int v;

  Admin({
    required this.id,
    required this.outlookEmail,
    required this.board,
    required this.position,
    required this.v,
  });

  factory Admin.fromRawJson(String str) => Admin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    id: json["_id"],
    outlookEmail: json["outlookEmail"],
    board: json["board"],
    position: json["position"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "outlookEmail": outlookEmail,
    "board": board,
    "position": position,
    "__v": v,
  };
}
