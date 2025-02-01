import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'package:pokemon_trainer_fitness_app/database/db_config.dart';

class DatabaseService {
  late MySqlConnection conn;

  // Conectar a BBDD
  Future<void> connect() async {
    // Primera conexion: sin BD
    final tempSettings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
    );

    // Intentar a Crear el BD si no existe.
    try {
      final tempConn = await MySqlConnection.connect(tempSettings);
      await tempConn.query('CREATE DATABASE IF NOT EXISTS pokemon_imc');
      await tempConn.close();

      // Conectar a BD de la App.
      conn = await MySqlConnection.connect(DatabaseConfig.settings);

      // Crear la tabla [trainer(user)]
      await conn.query('''
        CREATE TABLE IF NOT EXISTS trainer (
        trainer_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
        username varchar(50) NOT NULL,
        password varchar(50) NOT NULL,
        age int NOT NULL,
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
        recorded_at timestamp DEFAULT CURRENT_TIMESTAMP
        FOREIGN KEY (trainer_id) REFERENCES trainer(trainer_id)
      )''');

      // Crear la tabla [user_pokemon]
      await conn.query('''
        CREATE TABLE IF NOT EXISTS user_pokemon (
        record_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
        user_id int NOT NULL,
        pokemon_id int NOT NULL,
        pokemon_name varchar(50) NOT NULL,
        obtained_at timestamp DEFAULT CURRENT_TIMESTAMP
        FOREIGN KEY (user_id) REFERENCES trainer(user_id)
      )''');
    } catch (e) {
      print('Error: Problema con el BD, $e');
    }
  }
}
