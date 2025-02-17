class PokemonStats {
  String? name;
  double? height;
  double? weight;
  double? imc;

  PokemonStats({
    this.name,
    this.height,
    this.weight,
    this.imc,
  });

  PokemonStats.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    height = json['height'];
    weight = json['weight'];
    imc = json['imc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['height'] = height;
    data['weight'] = weight;
    data['imc'] = imc;
    return data;
  }
}
