import 'dart:io';
import 'package:pokemon_trainer_fitness_app/database/db_service.dart';

class UserLogin {
  final DatabaseService _db = DatabaseService();

  String inputUsername = '';
  String _inputPassword = '';
  bool isLogin = false;

  Future<void> login() async {
    await _db.connect();

    do {
      stdout.write('Nombre de Trainer: ');
      inputUsername = stdin.readLineSync() ?? '';
    } while (inputUsername.isEmpty);

    do {
      stdout.write('Contraseña: ');
      _inputPassword = stdin.readLineSync() ?? '';
    } while (_inputPassword.isEmpty);

    await _db.conn.query(
        'SELECT username, password FROM trainer WHERE username = ? AND password = ?',
        [inputUsername, _inputPassword]).then((results) {
      if (results.isNotEmpty) {
        print('✔ Bienvenido, $inputUsername');
        isLogin = true;
      } else {
        print('❌ El nombre de usuario o la contraseña no son correctos');
        login();
      }
    });
  }
}
