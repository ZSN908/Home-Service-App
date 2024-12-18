class AuthUtils {
  static bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^\+[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  static String? formatPhoneNumber(String phoneNumber, String countryCode) {
    String formatted =
        phoneNumber.startsWith('0') ? phoneNumber.substring(1) : phoneNumber;
    return formatted.isNotEmpty ? '$countryCode$formatted' : null;
  }

  // static bool isValidEmail(String email) {
  //   String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  //   return RegExp(emailPattern).hasMatch(email);
  // }

  static bool isValidEmail(String email) {
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    return RegExp(emailPattern).hasMatch(email);
  }

  // static bool isValidEmail(String email) {
  //   // Email Regex Validation
  //   String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  //   if (!RegExp(emailPattern).hasMatch(email)) {
  //     return false; // Invalid email structure
  //   }

  //   // Trusted Domains Check
  //   List<String> trustedDomains = [
  //     'gmail.com',
  //     'yahoo.com',
  //     'outlook.com',
  //     'hotmail.com',
  //     'icloud.com',
  //     'example.com', // Add more trusted domains as needed
  //   ];

  //   // Extract the domain part of the email
  //   String domain = email.split('@').last;

  //   return trustedDomains.contains(domain.toLowerCase());
  // }
}
