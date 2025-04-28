import 'package:mysql1/mysql1.dart';

class UserIMCHandler {
  final MySqlConnection conn;

  UserIMCHandler(this.conn);

  Future<void> showMyIMC(int trainerId) async {
    try {
      await conn.query('SELECT 1');

      var result = await conn.query(
          'SELECT imc, imc_status FROM user_imc WHERE trainer_id = ?',
          [trainerId]);

      if (result.isNotEmpty) {
        print(
            '𐄷 Tu IMC es ${result.first['imc']}(${result.first['imc_status']})\n');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
