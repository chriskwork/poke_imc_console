import 'dart:io';
import 'package:pokemon_trainer_fitness_app/init_screen.dart';

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

    double imcResult = userInfo.weight / (userInfo.height * userInfo.height);
    String imcStatus = '';

    // IMC Rango:
    // < 18.5 (bajo peso)
    // 18.5 - 22.9 (normal)
    // 23 - 24.9 (sobrepeso)
    // >= 25 (obesidad)

    if (imcResult < 18.5) {
      print('$imcStatus : Bajo Peso');
      showMainMenu();
    } else if (imcResult < 22.9) {
      print('$imcStatus : Normal');
      showMainMenu();
    } else if (imcResult < 24.9) {
      print('$imcStatus : Sobrepeso');
      showMainMenu();
    } else {
      print('$imcStatus : OBESIDAD');
      showMainMenu();
    }

    String imcMessage = '''
    
-> 📊 Tu IMC es ${imcResult.toStringAsFixed(1)} : $imcStatus

''';

    return imcMessage;
  }
}
