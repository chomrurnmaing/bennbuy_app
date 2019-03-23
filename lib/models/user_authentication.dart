class UserAuthentication{
  String usernameEmail;
  String password;

  UserAuthentication({
    this.usernameEmail,
    this.password
  });

  void clear(){
    this.usernameEmail = null;
    this.password = null;
  }
}