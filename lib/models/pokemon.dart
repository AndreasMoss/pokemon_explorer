class PokemonBasic {
  final String name;
  final String imageUrl;

  PokemonBasic({required this.name, required this.imageUrl});
}

class PokemonDetail {
  final String name;
  final String imageUrl;
  final String type;
  final int hp;
  final int attack;
  final int defense;
  final String description;

  PokemonDetail({
    required this.name,
    required this.imageUrl,
    required this.type,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.description,
  });
}
