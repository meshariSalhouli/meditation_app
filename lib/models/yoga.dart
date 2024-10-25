class Exercise {
  int? id;
  String title;
  String file;
  bool finished;

  Exercise(
      {this.id,
      required this.title,
      required this.file,
      required this.finished});

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
      id: json['id'],
      title: json['text'],
      file: json['file'],
      finished: json["finished"]);

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "text": title,
        "file": file,
        "finished": finished
      };
}
