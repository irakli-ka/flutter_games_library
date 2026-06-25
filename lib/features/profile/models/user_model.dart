class UserModel {
  final String username;
  final String email;
  final String profileImageUrl;

  UserModel({
    required this.username,
    required this.email,
  })
      : profileImageUrl = "https://api.dicebear.com/8.x/pixel-art/png?seed=$username";
}