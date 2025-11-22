class User {
  final String username;
  final String nickname;
  final String token;

  User({
    required this.username,
    required this.nickname,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      nickname: json['nickname'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'nickname': nickname,
      'token': token,
    };
  }
}
