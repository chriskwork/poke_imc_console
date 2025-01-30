import 'dart:io';
import 'dart:convert';

// Clase de Usuario
class User {
  late String _name, _password;

// Constructor
  User(
    String name,
    String password,
  ) {
    _name = name;
    _password = password;
  }

// Getter
  String get getName => _name;
  String get getPassword => _password;

// Setter
  set setName(String name) => _name = name;
  set setPassword(String password) => _password = password;

// Check la existencia de usuario, si es nuevo usuario, guardar el archivo.
  static Future<void> checkUser() async {
    final file = File('user.json');

    try {
      if (await file.exists()) {
        final content = await file.readAsString();
        final userData = jsonDecode(content);
        print(
            '=== ¡Hola ${userData['name']}! Qué alegría de verte otra vez. ===');
      } else {
        print('=== ¡Bienvenid@! Por favor, registrate primero. === \n');

        String name, password;

        do {
          stdout.write('Tu nombre(solo letras y números) : ');
          name = stdin.readLineSync()!.trim();
        } while (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(name));

        do {
          stdout.write('Contraseña : ');
          password = stdin.readLineSync()!.trim();
        } while (password.isEmpty);

        // Crear nuevo usuario y guardar su dato
        User newUser = User(name, password);

        await file.writeAsString(jsonEncode({
          'name': newUser.getName,
          'password': newUser.getPassword,
        }));

        print('''

### 
¡Bien hecho $name!,
Te recordaré hasta que uses '--borrar' comando. 
Vamos a empezar. 🙌
###''');
      }
    } catch (e) {
      print('error');
    }
  }

  // Borrar los datos de usuario para el test, o resetear la contraseña.
  static Future<void> deleteUserData() async {
    final file = File('user.json');
    await file.delete();

    print('### Tu dato está borrado.');
  }
}
