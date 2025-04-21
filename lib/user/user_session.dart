class UserSession {
  static int? trainerId;
  static String? userName;

  static void clearSession() {
    trainerId = null;
    userName = null;
  }
}
