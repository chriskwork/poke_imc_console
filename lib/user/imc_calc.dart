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

  double get height => _height;
  double get weight => _weight;

  set height(double height) => _height = height;
  set weight(double weight) => _weight = weight;

  void getUserInfo() {
    // Obtener la altura de usuario
    do {
      stdout.write('Introduce tu Altura(cm): ');
      height = double.parse(
        // Cambiar , a . para evitar error
        stdin.readLineSync()!.trim().replaceAll(',', '.'),
      );
      height.toStringAsFixed(1);
    } while (height <= 0);
    // Obtener el pero de usuario
    do {
      stdout.write('Introduce tu Peso(kg): ');
      weight = double.parse(
        stdin.readLineSync()!.trim().replaceAll(',', '.'),
      );
      weight.toStringAsFixed(1);
    } while (weight <= 0);
  }

  void checkMyInfo() {
    print('Altura: $height, Peso: $weight');
  }

  void getMyImc() {
    print('');
  }
}
