class Note {
  String id;
  String title;
  String content;
  bool isPinned;
  bool isArchived;
  DateTime updatedAt;

  Note({
    this.id,
    this.title,
    this.content,
    this.isPinned,
    this.isArchived,
    this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        isPinned: json["is_pinned"],
        isArchived: json["is_archived"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "is_pinned": isPinned,
        "is_archived": isArchived,
        "updated_at": updatedAt.toIso8601String(),
      };

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['content'] = content;
    map['is_pinned'] = isPinned;
    map['is_archived'] = isArchived;
    map['updated_at'] = updatedAt.toIso8601String();
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.content = map['content'];
    this.isPinned = map['is_pinned'];
    this.isArchived = map['is_archived'];
    this.updatedAt = DateTime.parse(map['updated_at']);
  }
}
