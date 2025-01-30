import 'dart:io';
import 'package:poke_imc_console/user/imc_calc.dart';
import 'package:poke_imc_console/user/user.dart';

String? command;

// Mostrar los comandos
void showCommand() {
  // Inicializar el comando
  command = null;

  print('''

### C O M A N D O S 👇
### Ver IMC de pokemon(Buscar con el nombre): --b
### Calcular mi IMC: --imc
### Borrar mis datos: --borrar
### Salir: --s

  ''');

  // Comando input prompt
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

// Ejecutar el comando
void exeCommand(String command) {
  switch (command) {
    case '--b':
      print('\n 🔍 Buscar IMC del pokemon por nombre \n');
      break;
    case '--imc':
      print('\n 🍎 Calcular mi IMC \n');
      ImcCalculator.getMyImc();
      break;
    case '--s':
      print('''

### ¡Hasta luego! 👋
                                    
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
