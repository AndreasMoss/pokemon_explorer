class PokemonType {
  final String title;
  final String icon;

  const PokemonType({required this.title, required this.icon});
}

const List<PokemonType> pokemonTypes = [
  PokemonType(title: 'Fire', icon: 'assets/images/icon_types/fire.svg'),
  PokemonType(title: 'Ghost', icon: 'assets/images/icon_types/ghost.svg'),
  PokemonType(title: 'Grass', icon: 'assets/images/icon_types/grass.svg'),
  PokemonType(title: 'Psychic', icon: 'assets/images/icon_types/psychic.svg'),
  PokemonType(title: 'Steel', icon: 'assets/images/icon_types/steel.svg'),
  PokemonType(title: 'Water', icon: 'assets/images/icon_types/water.svg'),
  PokemonType(title: 'Dark', icon: 'assets/images/icon_types/dark.svg'),
  PokemonType(title: 'Dragon', icon: 'assets/images/icon_types/dragon.svg'),
  PokemonType(title: 'Electric', icon: 'assets/images/icon_types/electric.svg'),
  PokemonType(title: 'Fairy', icon: 'assets/images/icon_types/fairy.svg'),
];
