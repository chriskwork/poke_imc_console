import 'dart:io';
import 'package:pokemon_trainer_fitness_app/database/db_service.dart';
import 'package:pokemon_trainer_fitness_app/user/user_regist.dart';
import 'package:pokemon_trainer_fitness_app/user/user_session.dart';
import 'package:pokemon_trainer_fitness_app/user/user_imc.dart';

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

      var result = await _db.conn.query(
        'SELECT trainer_id FROM trainer WHERE username = ? AND password = ?',
        [inputUsername, _inputPassword],
      );

      if (result.isNotEmpty) {
        final row = result.first;
        UserSession.trainerId = row['trainer_id'];
        UserSession.userName = inputUsername;

        print('\n✔ Bienvenido, $inputUsername \n');
        showMainMenu();
      }
    } catch (e) {
      throw Exception('Error: Problema con el BD, $e');
    } finally {
      await _db.conn.close();
    }
  }

  // Menu principal.
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

  // Menu principal. (login screen)
  Future<void> showMainMenu() async {
    while (true) {
      print('=== OPCIONES 👇 ===');
      print('1. Ver mi Pokémon');
      print('2. Ver mi IMC');
      print('3. Salir');

      stdout.write('Elige una opción');
      String option = stdin.readLineSync() ?? '';

      if (option == '1') {
        print('ver mi pokemon');
      } else if (option == '2') {
        if (UserSession.trainerId != null) {
          UserIMCHandler userIMC = UserIMCHandler(_db.conn);
          await userIMC.showMyIMC(UserSession.trainerId!);
        } else {
          print('⚠ No estás logueado.');
        }
      } else if (option == '3') {
        logout();
        break;
      } else {
        print('⚠ Opción inválida.');
        continue;
      }
    }
  }

  // void showMainMenu() {
  //   String? seletedOption;

  //   // Menu options
  //   print('=== OPCIONES 👇 ===');
  //   print('1. Ver mi Pokémon');
  //   print('2. Ver mi IMC');
  //   print('3. Salir');

  //   seletedOption = stdin.readLineSync() ?? '';

  //   switch (seletedOption) {
  //     case '1':
  //       print('Ver mi Pokémon');
  //       break;
  //     case '2':
  //       print('ver mi imc');
  //       break;
  //     case '3':
  //       UserLogin().logout();
  //       break;
  //     default:
  //       print('Por favor, elige una opción.\n');
  //       showMainMenu();
  //   }
  // }

  // User logout method
  void logout() async {
    if (isLogin) {
      isLogin = false;
      try {
        await _db.conn.close();
      } catch (e) {
        print('⚠️ Error al cerrar la conexión: $e');
      }

      // Inicializar session ID de usuario
      UserSession.clearSession();
    }

    print('\n👋 Hasta luego, $inputUsername \n');
  }
}
