import 'dart:io';

import 'package:poke_imc_console/init_screen.dart';

class ImcCalculator {
  late double _height;
  late double _weight;

  ImcCalculator(
    double height,
    double weight,
  ) {
    _height = height;
    _weight = weight;
  }

  double get height => _height;
  double get weight => _weight;

  set height(double height) => _height = height;
  set weight(double weight) => _weight = weight;

// Obtener la informacion y calcular IMC
  static String getMyImc() {
    double height, weight;

    // Obtener la altura de usuario
    do {
      stdout.write('Introduce tu Altura(cm): ');
      height = double.parse(
        // Cambiar , a . para evitar error
        stdin.readLineSync()!.trim().replaceAll(',', '.'),
      );
      height = height / 100;
    } while (height <= 0);

    // Obtener el pero de usuario
    do {
      stdout.write('Introduce tu Peso(kg): ');
      weight = double.parse(
        stdin.readLineSync()!.trim().replaceAll(',', '.'),
      );
      weight.toStringAsFixed(1);
    } while (weight <= 0);

    ImcCalculator userInfo = ImcCalculator(height, weight);

    double imc_result = userInfo.weight / (userInfo.height * userInfo.height);
    String imc_status = '';

    // IMC Rango:
    // < 18.5 (bajo peso)
    // 18.5 - 22.9 (normal)
    // 23 - 24.9 (sobrepeso)
    // >= 25 (obesidad)

    if (imc_result < 18.5) {
      print('$imc_status : Bajo Peso');
      showCommand();
    } else if (imc_result < 22.9) {
      print('$imc_status : Normal');
      showCommand();
    } else if (imc_result < 24.9) {
      print('$imc_status : Sobrepeso');
      showCommand();
    } else {
      print('$imc_status : OBESIDAD');
      showCommand();
    }

    String imc_message = '''
    
-> 📊 Tu IMC es ${imc_result.toStringAsFixed(1)} : $imc_status

''';

    return imc_message;
  }
}
