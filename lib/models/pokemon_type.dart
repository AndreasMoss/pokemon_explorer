import 'package:flutter/material.dart';

class PokemonType {
  final String title;
  final String icon;
  final Color color;
  const PokemonType({
    required this.title,
    required this.icon,
    required this.color,
  });
}

const List<PokemonType> pokemonTypes = [
  PokemonType(
    title: 'Fire',
    icon: 'assets/images/icon_types/fire.svg',
    color: Color(0xFFFFA756),
  ),
  PokemonType(
    title: 'Ghost',
    icon: 'assets/images/icon_types/ghost.svg',
    color: Color(0xFF7C538C),
  ),
  PokemonType(
    title: 'Grass',
    icon: 'assets/images/icon_types/grass.svg',
    color: Color(0xFF8BBE8A),
  ),
  PokemonType(
    title: 'Psychic',
    icon: 'assets/images/icon_types/psychic.svg',
    color: Color(0xFFFF6568),
  ),
  PokemonType(
    title: 'Steel',
    icon: 'assets/images/icon_types/steel.svg',
    color: Color(0xFF4C91B2),
  ),
  PokemonType(
    title: 'Water',
    icon: 'assets/images/icon_types/water.svg',
    color: Color(0xFF58ABF6),
  ),
  PokemonType(
    title: 'Dark',
    icon: 'assets/images/icon_types/dark.svg',
    color: Color(0xFF6F6E78),
  ),
  PokemonType(
    title: 'Dragon',
    icon: 'assets/images/icon_types/dragon.svg',
    color: Color(0xFF7383B9),
  ),
  PokemonType(
    title: 'Electric',
    icon: 'assets/images/icon_types/electric.svg',
    color: Color(0xFFF2CB55),
  ),
  PokemonType(
    title: 'Fairy',
    icon: 'assets/images/icon_types/fairy.svg',
    color: Color(0xFFEB8FE6),
  ),
];

PokemonType getPokemonTypeByTitle(String title) {
  return pokemonTypes.firstWhere(
    (type) => type.title.toLowerCase() == title.toLowerCase(),
    orElse: () => PokemonType(
      title: 'Any',
      icon: 'assets/images/icon_types/any.svg',
      color: Colors.grey,
    ),
  );
}
