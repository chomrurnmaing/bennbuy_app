String validateEmail(String value) {

  // This is just a regular expression for email addresses
  String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+";
  RegExp regExp = new RegExp(p);

  if (!regExp.hasMatch(value)) {

    // So, the email is valid
    return 'Email is not valid';

  } else if ( value.isEmpty ) {

    return "Email is required.";

  }

  // The pattern of the email didn't match the regex above.
  return null;
}

String validatePassword(String value){

  String msg;

  if ( value.isEmpty ) {
    msg = 'Please fill out the Password field.';
  } else if(value.length < 6){
    msg = 'Password must be or equal to 6 characters.';
  }

  return msg;
}

String requiredValidator(String value){
  if ( value.isEmpty ) {
    return 'This field is required.';
  }
  return null;
}
