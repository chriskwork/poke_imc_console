import 'package:mysql1/mysql1.dart';

class UserIMCHandler {
  late MySqlConnection conn;

  UserIMCHandler(this.conn);

  Future<void> showMyIMC(int trainerId) async {
    print(trainerId);
  }
}
