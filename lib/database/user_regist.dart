import 'dart:io';
import 'package:pokemon_trainer_fitness_app/database/db_service.dart';
import 'package:pokemon_trainer_fitness_app/database/user_login.dart';
import 'package:pokemon_trainer_fitness_app/user/user.dart';

class UserRegistHandler {
  final DatabaseService _db = DatabaseService();

  // Probar el nombre de trainer existe o no
  Future<String> checkUniqueName() async {
    String username;
    bool isUnique = false;

    do {
      stdout.write('(1/4) Crear un nombre que deseas => ');
      username = stdin.readLineSync() ?? '';
      if (username.isEmpty) {
        print('⚠ El nombre no puede ser vacio');
        continue;
      }

      // Check BBDD si el nombre existe

      var results = await _db.conn
          .query('SELECT username FROM trainer WHERE username = ?', [username]);

      // Si no sale el nombre que esta elegido en resultado de query,
      // ya puede usar el nombre.
      if (results.isEmpty) {
        print('✔ Puedes usar este nombre');
        isUnique = !isUnique;
      } else {
        print('❌ El nombre ya extiste. Elige otro nombre.');
        continue;
      }
    } while (!isUnique);

    return username;
  }

  // Obtener la información de user
  Future<User> newUserRegistInput() async {
    User userInfo;

    try {
      print('=== Registrar como Trainer === \n');

      String username = await checkUniqueName();

      stdout.write('(2/4) Introduce la contraseña => ');
      String password = stdin.readLineSync() ?? '';
      if (password.isEmpty) throw Exception('La contraseña es obligatoria');

      stdout.write('(3/4) Introduce tu altura(*metro) => ');
      double height = double.tryParse(
            stdin.readLineSync()!.trim().replaceAll(',', '.'),
          ) ??
          0;
      if (height <= 0 || height >= 100) {
        throw Exception('El valor no está validad');
      }

      stdout.write('(4/4) Introduce tu peso(*kg) => ');
      double weight = double.tryParse(
            stdin.readLineSync()!.trim().replaceAll(',', '.'),
          ) ??
          0;
      if (weight <= 0) {
        throw Exception('El valor no está validad');
      }

      userInfo = User(
        username: username,
        password: password,
        height: height,
        weight: weight,
      );
    } catch (e) {
      throw Exception('Error, $e');
    }

    return userInfo;
  }

  // Registrar nuevo user a los BBDD
  Future<void> newUserRegister() async {
    String imcStatus = '';

    try {
      await _db.connect();

      final user = await newUserRegistInput();

      var result = await _db.conn.query(
          'INSERT INTO trainer (username, password) VALUES (?, ?)',
          [user.username, user.password]);

      final trainerId = result.insertId;

      // Calcular IMC
      double userImc = user.weight / (user.height * user.height);

      if (userImc < 18.5) {
        imcStatus = 'Bajo Peso';
      } else if (userImc < 22.9) {
        imcStatus = 'Normal';
      } else if (userImc < 24.9) {
        imcStatus = 'Sobrepeso';
      } else {
        imcStatus = 'Obesidad';
      }

      await _db.conn.query(
        'INSERT INTO imc (trainer_id, height, weight, imc, imc_status) VALUES (?, ?, ?, ?, ?)',
        [trainerId, user.height, user.weight, userImc, imcStatus],
      );

      print('\n🙌 ¡Registro completado con éxito!');

      UserLogin().showMainMenu();
    } catch (e) {
      throw Exception('Error, $e');
    } finally {
      await _db.conn.close();
    }
  }
}
