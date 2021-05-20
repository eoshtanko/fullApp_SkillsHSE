
class Validator{

  static bool isValidNameOrSurname(String name){
    return name != null && name.length > 1 && name.length <= 40;
  }

  static bool isValidEmail(String email){
    return email != null && email.toLowerCase().endsWith("@edu.hse.ru") && email.length > 11;
  }

  static bool isValidPassword(String pass){
    return pass != null && pass.length >= 6 && pass.length <= 40;
  }
}