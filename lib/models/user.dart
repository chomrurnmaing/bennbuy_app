class User{
  String username;
  String nicename;
  String email;
  String url;
  String registered;
  String displayName;
  String firstName;
  String lastName;
  String nickname;
  String description;
  String capabilities;
  String avatar;

  User({
    this.username,
    this.nicename,
    this.email,
    this.registered,
    this.displayName,
    this.firstName,
    this.lastName,
    this.nickname,
    this.description,
    this.capabilities,
    this.avatar
  });

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      username: data['username'],
      nicename: data['nicname'],
      email: data['email'],
      registered: data['registered'],
      displayName: data['displayname'],
      firstName: data['firstname'],
      lastName: data['lastname'],
      nickname: data['nickname'],
      description: data['description'],
      capabilities: data['capabilities'],
      avatar: data['avatar']
    );
  }
}