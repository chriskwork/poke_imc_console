import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'package:pokemon_trainer_fitness_app/database/db_config.dart';

class DatabaseService {
  late MySqlConnection conn;
  bool isInit = false;
  // Conectar a BBDD
  Future<void> connect() async {
    if (!isInit) {
      // Primera conexion: sin BD
      final tempSettings = ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
      );

      // Intentar a Crear el BD si no existe.
      // Primnero se conecta con setting temporal,
      // y luego crea el BD(pokemon_imc) que vamos a gardar datos.
      try {
        final tempConn = await MySqlConnection.connect(tempSettings);
        await tempConn.query('CREATE DATABASE IF NOT EXISTS pokemon_imc');
        await tempConn.close();

        // Conectar a BD de la App.
        conn = await MySqlConnection.connect(DatabaseConfig.settings);

        // Iniciar tablas (Crear las tablas si no existen)
        // estará abierto despues de hacer registracion o login.
        await _initialTables();
        await initPokemonData();
        isInit = true;
      } catch (e) {
        print('Error: connect(), $e');
      }
    } else {
      conn = await MySqlConnection.connect(DatabaseConfig.settings);
    }
  }

  Future<void> _initialTables() async {
    // Crear la tabla [trainer(user)]
    await conn.query('''
        CREATE TABLE IF NOT EXISTS trainer (
        trainer_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
        username varchar(50) NOT NULL,
        password varchar(50) NOT NULL,
        created_at timestamp DEFAULT CURRENT_TIMESTAMP
      )''');

    // Crear la tabla [imc]
    await conn.query('''
        CREATE TABLE IF NOT EXISTS imc (
        record_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
        trainer_id int NOT NULL,
        height decimal(5,2) NOT NULL,
        weight decimal(5,2) NOT NULL,
        imc decimal(3,1) NOT NULL,
        imc_status varchar(10) NOT NULL,
        recorded_at timestamp DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (trainer_id) REFERENCES trainer(trainer_id)
      )''');

    // Crear la tabla [pokemon_stats]
    await conn.query('''
        CREATE TABLE IF NOT EXISTS pokemon_stats (
        pokemon_id int NOT NULL PRIMARY KEY,
        pokemon_name varchar(50) NOT NULL,
        height decimal(5,2) NOT NULL,
        weight decimal(5,2) NOT NULL,
        imc decimal(3,1) NOT NULL
      )''');

    // Crear la tabla [user_pokemon]
    await conn.query('''
        CREATE TABLE IF NOT EXISTS user_pokemon (
        record_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
        trainer_id int NOT NULL,
        pokemon_id int NOT NULL,
        pokemon_name varchar(50) NOT NULL,
        obtained_at timestamp DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (trainer_id) REFERENCES trainer(trainer_id),
        FOREIGN KEY (pokemon_id) REFERENCES pokemon_stats(pokemon_id)
      )''');
  }

  // Registrar los datos de pokemon
  Future<void> initPokemonData() async {
    try {
      var result = await conn.query('SELECT COUNT(*) FROM pokemon_stats');
      int count = result.first['count'] ?? 0;

      if (count > 0) {
        print('✔ Los datos de Pokémon ya están inicializados');
        return;
      }

      // Traer los datos de la API
      // print('🔄 Inicializando datos de Pokémon...');

      for (int i = 1; i <= 151; i++) {
        final res =
            await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$i'));

        if (res.statusCode == 200) {
          final data = json.decode(res.body);

          // Obtener IMC de Pokemon
          double pokemonHeight = data['height'] / 10;
          double pokemonWeight = data['weight'] / 10;
          double pokemonImc = pokemonWeight / (pokemonHeight * pokemonHeight);

          await conn.query(
              'INSERT INTO pokemon_stats (pokemon_id, pokemon_name, height, weight, imc) VALUES (?, ?, ?, ?, ?)',
              [
                data['id'],
                data['name'],
                pokemonHeight,
                pokemonWeight,
                pokemonImc
              ]);
        }
      }

      // print('✨ Inicialización de Pokémon completada');
    } catch (e) {
      print('');
    }
  }
}
