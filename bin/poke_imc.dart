// import 'package:poke_imc/user/user.dart';
import 'dart:io';

late String command;
void main() {
  welcome();
}

void welcome() {
  // Mensaje del Inicio
  print('''

###################################
###                             ###
### Bienvenid@s a Poke-IMC App! ###
###                             ###
###################################
''');

  showCommand();

  // switch (answer) {
  //   case '--r':
  //     break;
  //   case '--i':
  //     break;
  //   case '--b':
  //     break;
  //   case '--imc':
  //     break;
  //   case '--h':
  //     break;
  //   default:
  // }
}

void showCommand() {
  print('''

* COMANDOS 👇
* Registrar/Iniciar: --r o --i
* Ver IMC de pokemon(Buscar con el nombre): --b
* Calcular mi IMC: --imc
* Ver todos comandos: --h

  ''');

  do {
    stdout.write('> ');
    command = stdin.readLineSync()!.trim();
  } while (!RegExp(r'^--[a-z]+$').hasMatch(command));
}
