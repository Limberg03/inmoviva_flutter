class User {
  int id;
  String name;
  String email;
  dynamic currentTeamId;
  dynamic profilePhotoPath;
  dynamic createdAt;
  dynamic updatedAt;
  String profilePhotoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.currentTeamId,
    required this.profilePhotoPath,
    required this.createdAt,
    required this.updatedAt,
    required this.profilePhotoUrl,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        email = json["email"],
        currentTeamId = json["current_team_id"],
        profilePhotoPath = json["profile_photo_path"],
        createdAt = json["created_at"],
        updatedAt = json["updated_at"],
        profilePhotoUrl = json["profile_photo_url"];
}
