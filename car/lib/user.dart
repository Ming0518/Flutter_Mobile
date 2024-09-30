class User {
  // ignore: non_constant_identifier_names
  String? user_id;
  String? username;
  String? password;

  User({
    this.user_id,
    this.username,
    this.password,
  });

  User.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = user_id;
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}
