import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_trainer_fitness_app/database/db_service.dart';
import 'package:pokemon_trainer_fitness_app/user/user_login.dart';
import 'package:pokemon_trainer_fitness_app/user/user.dart';
import 'package:pokemon_trainer_fitness_app/user/user_session.dart';

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
    try {
      await _db.connect();

      final user = await newUserRegistInput();

      var result = await _db.conn.query(
          'INSERT INTO trainer (username, password) VALUES (?, ?)',
          [user.username, user.password]);

      final trainerId = result.insertId;

      // Coger user ID para servir sus datos
      UserSession.trainerId = trainerId;
      UserSession.userName = user.username;

      // Calcular IMC
      double userImc = user.weight / (user.height * user.height);

      String imcStatus = imcStatusLogic(userImc);

      // Guardar IMC en BBDD
      await _db.conn.query(
        'INSERT INTO user_imc (trainer_id, height, weight, imc, imc_status) VALUES (?, ?, ?, ?, ?)',
        [trainerId, user.height, user.weight, userImc, imcStatus],
      );

      print('\n🙌 ¡Registro completado con éxito! \n');

      await initPokemonData();
      await UserLogin().showMainMenu();
    } catch (e) {
      throw Exception('Error, $e');
    }
  }

  // Conctar a pokeAPI y traer, guardar los datos en BBDD
  // usaré solo 100 pokemones
  Future<void> initPokemonData() async {
    try {
      var result =
          await _db.conn.query('SELECT COUNT(*) as total FROM pokemon_stats');
      int count = result.first['total'] ?? 0;

      if (count > 0) return;

      // Traer los datos de la API
      print('🔄 Inicializando datos de Pokémon...');

      for (int i = 1; i <= 100; i++) {
        final res =
            await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$i'));

        if (res.statusCode == 200) {
          final data = json.decode(res.body);

          // Obtener IMC de Pokemon
          double pokemonHeight = data['height'] / 10;
          double pokemonWeight = data['weight'] / 10;
          double pokemonImc = pokemonWeight / (pokemonHeight * pokemonHeight);

          String pokemonImcStatus = imcStatusLogic(pokemonImc);

          await _db.conn.query(
              'INSERT INTO pokemon_stats (pokemon_id, pokemon_name, height, weight, imc, imc_status) VALUES (?, ?, ?, ?, ?, ?)',
              [
                data['id'],
                data['name'],
                pokemonHeight,
                pokemonWeight,
                pokemonImc,
                pokemonImcStatus
              ]);
        }

        if (i % 10 == 0) {
          print('🔄 Cargando $i%...');
        }
      }

      print('\n');
    } catch (e) {
      print(e);
    }
  }

  String imcStatusLogic(double pokemonImc) {
    var pokemonImcStatus = '';

    // Clasificar estado del IMC
    if (pokemonImc < 18.5) {
      pokemonImcStatus = 'Bajo Peso';
    } else if (pokemonImc < 22.9) {
      pokemonImcStatus = 'Normal';
    } else if (pokemonImc < 24.9) {
      pokemonImcStatus = 'Sobrepeso';
    } else {
      pokemonImcStatus = 'Obesidad';
    }

    return pokemonImcStatus;
  }
}
