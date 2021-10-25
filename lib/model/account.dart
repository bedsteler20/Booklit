class Account {
  final Uri profilePicture;
  final String name;
  final String? email;
  final String clientId;
  final String token;

  const Account({
    this.email,
    required this.name,
    required this.profilePicture,
    required this.clientId,
    required this.token,
  });

  Map toMap() => {
        "email": email,
        "name": name,
        "clientId": clientId,
        "token": token,
        "profilePicture": profilePicture.toString(),
      };

  factory Account.fromMap(Map map) {
    return Account(
      clientId: map["clientId"],
      name: map["name"],
      profilePicture: Uri.parse(map["profilePicture"]),
      token: map["token"],
      email: map["email"],
    );
  }
}
