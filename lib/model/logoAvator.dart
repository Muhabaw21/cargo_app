

class LogoAndAvatar {
  final String avatar;
  final String logo;

  LogoAndAvatar({required this.avatar, required this.logo});

  factory LogoAndAvatar.fromJson(Map json) {
    return LogoAndAvatar(
      avatar: json['avatar'],
      logo: json['logo'],
    );
  }
}