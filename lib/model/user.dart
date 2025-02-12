class User {
  String? user_name;
  String? email;
  String? password;
  String? c_password;
  User({
    this.user_name,
    this.email,
    this.password,
    this.c_password,
  });

  User.fromJson(Map<String, dynamic> json) {
    user_name = json['user_name'] ?? "";
    email = json['email'] ?? "";
    password = json['password'] ?? "";
    c_password = json['c_password'] ?? "";
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_name'] = user_name;
    data['email'] = email;
    data['password'] = password;
    data['c_password'] = c_password;
    return data;
  }
}
