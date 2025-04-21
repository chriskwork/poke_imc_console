import 'dart:io';
import 'package:pokemon_trainer_fitness_app/database/db_service.dart';
import 'package:pokemon_trainer_fitness_app/user/user_regist.dart';

class UserLogin {
  final DatabaseService _db = DatabaseService();

  String inputUsername = '';
  String _inputPassword = '';

  bool isLogin = false;

  Future<void> login() async {
    await _db.connect();

    try {
      do {
        stdout.write('Nombre de Trainer: ');
        inputUsername = stdin.readLineSync() ?? '';
        if (inputUsername == '0') {
          print('\n');
          inputUsername = '';
          showInitMenu();
          continue;
        }
      } while (inputUsername.isEmpty);

      do {
        stdout.write('Contraseña: ');
        _inputPassword = stdin.readLineSync() ?? '';
        if (_inputPassword == '0') {
          print('\n');
          _inputPassword = '';
          showInitMenu();
          continue;
        }
      } while (_inputPassword.isEmpty);

      await _db.conn.query(
          'SELECT username, password FROM trainer WHERE username = ? AND password = ?',
          [inputUsername, _inputPassword]).then((results) {
        if (results.isNotEmpty) {
          print('\n✔ Bienvenido, $inputUsername \n');
          isLogin = true;
          showMainMenu();
        } else {
          print(
              '❌ El nombre de usuario o la contraseña no son correctos. \n Para volver al Menú, pulsa 0.');
          login();
        }
      });
    } catch (e) {
      throw Exception('Error: Problema con el BD, $e');
    } finally {
      await _db.conn.close();
    }
  }

  void logout() async {
    if (isLogin) {
      isLogin = false;
      try {
        await _db.conn.close();
      } catch (e) {
        print('⚠️ Error al cerrar la conexión: $e');
      }
    }

    print('\n👋 Hasta luego, $inputUsername \n');
  }

  // Menu principal. (!login)
  void showInitMenu() {
    String? seletedOption;

    // Menu options
    print('=== OPCIONES 👇 ===');
    print('1. Login');
    print('2. Registrar\n');

    seletedOption = stdin.readLineSync() ?? '';

    switch (seletedOption) {
      case '1':
        print('🔄 Cargando...');
        UserLogin().login();
        break;
      case '2':
        print('🔄 Cargando...');
        UserRegistHandler().newUserRegister();
        break;
      case '0':
        showInitMenu();
        break;
      default:
        print('Por favor, elige una opción.\n');
        showInitMenu();
    }
  }

  // Menu principal. (login)
  void showMainMenu() {
    String? seletedOption;

    // Menu options
    print('=== OPCIONES 👇 ===');
    print('1. Ver mi Pokémon');
    print('2. Ver mi IMC');
    print('3. Salir');

    seletedOption = stdin.readLineSync() ?? '';

    switch (seletedOption) {
      case '1':
        print('Ver mi Pokémon');
        break;
      case '2':
        print('ver mi imc');
        break;
      case '3':
        UserLogin().logout();
        break;
      default:
        print('Por favor, elige una opción.\n');
        showMainMenu();
    }
  }
}
