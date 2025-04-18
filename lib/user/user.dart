// User model
class User {
  final int? id;
  final String username;
  final String _password;
  double _height;
  double _weight;

  // Constructor
  User({
    this.id,
    required this.username,
    required String password,
    required double height,
    required double weight,
  })  : _password = password,
        _height = height,
        _weight = weight;

  // Getter
  String get password => _password;
  double get height => _height;
  double get weight => _weight;

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
}
