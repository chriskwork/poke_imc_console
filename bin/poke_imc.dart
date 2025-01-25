import 'dart:io';
import 'package:poke_imc_console/user/user.dart';

String? command;

void main() async {
  await welcome();
}

Future<void> welcome() async {
  // Mensaje del Inicio
  print('''

###################################
###                             ###
### Bienvenid@ a Poke-IMC App!  ###
###                             ###
###################################
''');

  await User.checkUser();

  showCommand();
}

// Mostrar los comandos
void showCommand() {
  command = null;

  print('''

### COMANDOS 👇
### Ver IMC de pokemon(Buscar con el nombre): --b
### Calcular mi IMC: --imc
### Borrar mis datos: --borrar
### Salir: --s

  ''');

  if (command == null) {
    do {
      stdout.write('> ');
      command = stdin.readLineSync()!.trim();
    } while (!RegExp(r'^--[a-z]+$').hasMatch(command!));
    exeCommand(command!);
  } else {
    exeCommand(command!);
  }
}

void exeCommand(String command) {
  switch (command) {
    case '--b':
      print('Buscar IMC del pokemon por nombre');
      break;
    case '--imc':
      print('Calcular mi IMC');
      break;
    case '--s':
      print('''

### ¡Hasta luego! (ʘ‿ʘ)╯    
                                    
  ''');
      break;
    case '--borrar':
      User.deleteUserData();
      break;
    default:
      print('Comando incorrecto. Reintenta por favor.');
      showCommand();
  }
}
