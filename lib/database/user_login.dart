import 'dart:io';
import 'package:pokemon_trainer_fitness_app/database/db_service.dart';
import 'package:pokemon_trainer_fitness_app/database/user_regist.dart';

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
      } while (inputUsername.isEmpty);

      do {
        stdout.write('Contraseña: ');
        _inputPassword = stdin.readLineSync() ?? '';
      } while (_inputPassword.isEmpty);

      await _db.conn.query(
          'SELECT username, password FROM trainer WHERE username = ? AND password = ?',
          [inputUsername, _inputPassword]).then((results) {
        if (results.isNotEmpty) {
          print('✔ Bienvenido, $inputUsername \n');
          isLogin = true;
          showMainMenu();
        } else {
          print('❌ El nombre de usuario o la contraseña no son correctos \n');
          login();
        }
      });
    } catch (e) {
      throw Exception('Error: Problema con el BD, $e');
    } finally {
      await _db.conn.close();
    }
  }

  void logout() {
    isLogin = false;
    print('👋 Hasta luego, $inputUsername \n');
  }

  // Menu principal. (!login)
  void showInitMenu() {
    String? seletedOption;

    // Menu options
    print('=== OPCIONES 👇 ===');
    print('1. Login');
    print('2. Registrar');

    seletedOption = stdin.readLineSync() ?? '';

    switch (seletedOption) {
      case '1':
        UserLogin().login();
        break;
      case '2':
        UserRegistHandler().newUserRegister();
        break;
      default:
        print('Por favor, elige una opción.\n');
        showMainMenuHandler();
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
        showMainMenuHandler();
    }
  }

  // Controlador de menu principal
  // muestra el menu diferente depende del usuario esta logeado o no.
  void showMainMenuHandler() {
    if (isLogin) {
      showMainMenu();
    } else {
      showInitMenu();
    }
  }
}
