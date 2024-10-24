class Tip {
  int? id;
  String text;
  String author;
  List<int> upVote = [];
  List<int> downVote = [];

  Tip({this.id, required this.text, required this.author});

  factory Tip.fromJson(Map<String, dynamic> json) => Tip(
        id: json['id'],
        text: json['text'],
        author: json['author'],
      );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{"id": id, "text": text, "author": author};
}
