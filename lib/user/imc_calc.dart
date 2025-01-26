import 'dart:io';

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

  double get getHeight => _height;
  double get getWeight => _weight;

  set setHeight(double height) => _height = height;
  set setWeight(double weight) => _weight = weight;

  static void getMyImc() {
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

    print(
        'Tu IMC es ${(userInfo.getWeight / (userInfo.getHeight * userInfo.getHeight)).toStringAsFixed(1)}');
  }
}
