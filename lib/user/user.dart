import 'dart:io';

// Clase de Usuario
class User {
  final List<Map<String, dynamic>> users = [];
  bool isLogin = false;

  late String _name;
  late String _password;

// Constructor
  User(
    String name,
    String password,
  ) {
    _name = name;
    _password = password;
  }

// Getter
  String get name => _name;
  String get password => _password;

// Setter
  set name(String name) => _name = name;
  set password(String password) => _password = password;

  void who() {
    print("Name: $name, Pwd: $password");
  }

// Registarse
  void signUp() {
    // Crear el nombre de usuario
    do {
      stdout.write('Nombre: ');
      name = stdin.readLineSync()!.trim();
    } while (name == '');
    // Crear la contraseña de usuario
    do {
      stdout.write('Contraseña: ');
      password = stdin.readLineSync()!.trim();
    } while (password == '');

    // Crear nuevo usuario
    Map<String, dynamic> newUser = {
      'name': name,
      'password': password,
    };

    // Añadir nuevo usuario a la lista
    users.add(newUser);
  }

  void logIn(String name, String password) {}
}
