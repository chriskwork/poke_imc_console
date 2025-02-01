// User model
class User {
  final int? id;
  final String username;
  final String _password;
  final int age;
  double _height;
  double _weight;
  final double _imc;

  // Constructor
  User({
    this.id,
    required this.username,
    required String password,
    required this.age,
    required double height,
    required double weight,
    required double imc,
  })  : _password = password,
        _height = height,
        _weight = weight,
        _imc = imc;

  // Getter
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

  set imc(double value) {}

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

  // Calcular el IMC de usuario
  double imcCalculator() {
    double userImc = _weight / ((_height / 100) * (_height / 100));
    return double.parse(userImc.toStringAsFixed(1));
  }

  // Map data de usuario para el BBDD.
  Map<String, dynamic> userMap() {
    return {
      'username': username,
      'password': _password,
      'age': age,
      'height': _height,
      'weight': _weight,
      'imc': _imc,
    };
  }
}
