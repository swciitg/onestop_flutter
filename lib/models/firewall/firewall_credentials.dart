import 'dart:convert';

class Credentials {
  final String username;
  final String password;

  Credentials({required this.password, required this.username});

  factory Credentials.fromJson(Map<String, dynamic> json) {
    return Credentials(
        password: json['password'] ?? "", username: json['username'] ?? "");
  }

  factory Credentials.fromString(String s) {
    return Credentials.fromJson(jsonDecode(s));
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
