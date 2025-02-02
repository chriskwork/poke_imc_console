// main.dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mysql1/mysql1.dart';

// 데이터베이스 설정
class DatabaseConfig {
  static final settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'your_username',
    password: 'your_password',
    db: 'pokemon_trainer_db'
  );
}

// 사용자 모델
class User {
  final int? id;
  final String username;
  String _password;
  final int age;
  double _height;
  double _weight;

  User({
    this.id,
    required this.username,
    required String password,
    required this.age,
    required double height,
    required double weight,
  }) : _password = password,
       _height = height,
       _weight = weight;

  // Getters
  double get height => _height;
  double get weight => _weight;
  
  // Setters
  set height(double value) {
    if (value > 0) {
      _height = value;
    } else {
      throw Exception('키는 0보다 커야 합니다.');
    }
  }
  
  set weight(double value) {
    if (value > 0) {
      _weight = value;
    } else {
      throw Exception('몸무게는 0보다 커야 합니다.');
    }
  }
  
  // 비밀번호 검증 메소드
  bool verifyPassword(String inputPassword) {
    return _password == inputPassword;
  }
  
  // 비밀번호 변경 메소드
  void updatePassword(String oldPassword, String newPassword) {
    if (verifyPassword(oldPassword)) {
      _password = newPassword;
    } else {
      throw Exception('현재 비밀번호가 일치하지 않습니다.');
    }
  }

  double calculateBMI() {
    return _weight / ((_height / 100) * (_height / 100));
  }
  
  // DB 저장용 Map 변환 메소드
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': _password,
      'age': age,
      'height': _height,
      'weight': _weight,
    };
  }
}

// 데이터베이스 서비스
class DatabaseService {
  late MySqlConnection conn;

  Future<void> connect() async {
    conn = await MySqlConnection.connect(DatabaseConfig.settings);
  }

  Future<User?> loginUser(String username, String password) async {
    var results = await conn.query(
      'SELECT * FROM Users WHERE username = ? AND password = ?',
      [username, password]
    );
    
    if (results.isNotEmpty) {
      var row = results.first;
      return User(
        id: row['user_id'],
        username: row['username'],
        password: row['password'],
        age: row['age'],
        height: row['height'],
        weight: row['current_weight'],
      );
    }
    return null;
  }

  Future<bool> registerUser(User user) async {
    try {
      var userData = user.toMap();
      await conn.query(
        'INSERT INTO Users (username, password, age, height, current_weight) VALUES (?, ?, ?, ?, ?)',
        [userData['username'], userData['password'], userData['age'], userData['height'], userData['weight']]
      );
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }
}

// Pokemon API 서비스
class PokemonService {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  Future<Map<String, dynamic>> getPokemon(String nameOrId) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$nameOrId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load pokemon');
    }
  }

  String recommendPokemon(double bmi) {
    if (bmi < 18.5) {
      return 'pidgey'; // 비행 타입
    } else if (bmi < 25) {
      return 'eevee'; // 노말 타입
    } else {
      return 'machop'; // 격투 타입
    }
  }
}

// 메인 앱 클래스
class PokemonTrainerApp {
  final DatabaseService _db = DatabaseService();
  final PokemonService _pokemonService = PokemonService();
  User? currentUser;

  Future<void> start() async {
    await _db.connect();
    
    while (true) {
      if (currentUser == null) {
        await showLoginMenu();
      } else {
        await showMainMenu();
      }
    }
  }

  void showWelcomeMessage() {
    print('\n===== 포켓몬 트레이너 건강 관리 시스템 =====');
    print('\n[한국어]');
    print('이 앱은 자신과 같은 체질량지수(IMC)를 가진 포켓몬을 찾거나,');
    print('체질량지수를 개선하고 더 나은 포켓몬을 얻으며 재미있게 건강을 관리할 수 있도록 돕는 앱입니다.\n');
    
    print('[Español]');
    print('Esta aplicación te ayuda a encontrar Pokémon que comparten tu Índice de Masa Corporal (IMC),');
    print('o mejorar tu IMC para conseguir diferentes Pokémon mientras cuidas tu salud de una manera divertida.\n');
  }

  Future<void> showLoginMenu() async {
    showWelcomeMessage();
    print('1. 로그인');
    print('2. 회원가입');
    print('3. 종료');
    print('선택: ');

    String? choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        await login();
        break;
      case '2':
        await register();
        break;
      case '3':
        exit(0);
      default:
        print('잘못된 선택입니다.');
    }
  }

  Future<void> showMainMenu() async {
    print('\n===== 메인 메뉴 =====');
    print('1. BMI 계산 및 포켓몬 추천');
    print('2. 내 정보 보기');
    print('3. 로그아웃');
    print('선택: ');

    String? choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        await calculateBMIAndRecommendPokemon();
        break;
      case '2':
        showUserInfo();
        break;
      case '3':
        currentUser = null;
        break;
      default:
        print('잘못된 선택입니다.');
    }
  }

  // TODO: Implement login(), register(), calculateBMIAndRecommendPokemon(), showUserInfo() methods
}

void main() async {
  final app = PokemonTrainerApp();
  await app.start();
}
