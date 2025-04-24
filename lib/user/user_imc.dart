import 'package:mysql1/mysql1.dart';

class UserIMCHandler {
  late MySqlConnection conn;

  UserIMCHandler(this.conn);

  Future<void> showMyIMC(int trainerId) async {
    var result = await conn.query(
        'SELECT imc, imc_status FROM user_imc WHERE trainer_id = ?',
        [trainerId]);

    if (result.isNotEmpty) {
      print(
          '𐄷 Tu IMC es ${result.first['imc']}(${result.first['imc_status']})\n');
    }
  }
}
