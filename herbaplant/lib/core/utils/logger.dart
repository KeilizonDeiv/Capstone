class AppLogger {
  static void log(String message) {
    final time = DateTime.now().toIso8601String();
    print('[$time] => $message');
  }
}
