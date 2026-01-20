
class ValidationService {
  // Valide une adresse e-mail.
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'L\'e-mail ne peut pas être vide.';
    }
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Veuillez entrer une adresse e-mail valide.';
    }
    return null;
  }

  // Valide un mot de passe.
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Le mot de passe ne peut pas être vide.';
    }
    if (password.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères.';
    }
    // Ajoutez d'autres règles de complexité si nécessaire (majuscules, chiffres, etc.)
    return null;
  }
}
