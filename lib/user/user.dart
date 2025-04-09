// User model
class User {
  final int? id;
  final String username;
  final String _password;
  double _height;
  double _weight;
  double _imc;
  String imcStatus = "";

  // Constructor
  User({
    this.id,
    required this.username,
    required String password,
    required double height,
    required double weight,
    required double imc,
  })  : _password = password,
        _height = height,
        _weight = weight,
        _imc = imc;

  // Getter
  String get password => _password;
  double get height => _height;
  double get weight => _weight;
  double get imc => _imc;

  // Setter
  set height(double value) {
    if (value > 0) {
      _height = value;
    } else {
      throw Exception('La altura tiene que ser mayor que 0');
    }
  }

  set weight(double value) {
    if (value > 0) {
      _weight = weight;
    } else {
      throw Exception('El peso tiene que ser mayor que 0');
    }
  }

  set imc(double value) {
    String msgTemplate = 'Tu IMC es $imc :';

    if (value > 0) {
      _imc = imc;

      if (value < 18.5) {
        imcStatus = '$msgTemplate Bajo de peso.';
      } else if (value < 24.9) {
        imcStatus = '$msgTemplate Peso normal.';
      } else if (value < 29.9) {
        imcStatus = '$msgTemplate Sobrepeso.';
      } else if (value < 34.9) {
        imcStatus = '$msgTemplate Obesidad ligera.';
      } else if (value < 39.9) {
        imcStatus = '$msgTemplate Obesidad';
      } else {
        imcStatus = '$msgTemplate Obesidad EXTREMA';
      }
    } else {
      throw Exception('El valor no está válido.');
    }
  }

  void printImcStatus() {
    print(imcStatus);
  }

  // Verificar la contraseña
  bool verifyPassword(String inputPassword) {
    return _password == inputPassword;
  }

  // Actualizar la contraseña
  void updatePassword(
    String oldPassword,
    String newPassword,
  ) {
    if (verifyPassword(oldPassword)) {
      _password == newPassword;
    } else {
      throw Exception('La contraseña incorrecta.');
    }
  }
}
