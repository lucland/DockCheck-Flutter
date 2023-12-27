class Picture {
  String id;
  String userId;
  String picture;

  Picture({
    required this.id,
    required this.userId,
    required this.picture,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json['id'],
      userId: json['user_id'],
      picture: json['picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'picture': picture,
    };
  }
}
