class User {
  int? id;
  String username;
  String password;

  User({
    required this.username,
    required this.password,
    this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{"id": id, "username": username, "password": password};
}
