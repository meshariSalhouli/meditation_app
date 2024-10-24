class User {
  int id;
  String username;
  String image;

  User({
    required this.username,
    required this.image,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{"id": id, "username": username, "image": image};
}
