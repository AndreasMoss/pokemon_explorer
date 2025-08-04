import 'package:flutter/material.dart';
import 'package:pokemon_explorer/functions/general.dart';

class PokemonDetail extends StatelessWidget {
  const PokemonDetail({super.key, required this.pokemonName});

  final String pokemonName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '${pokemonNameFormatter(pokemonName)} Detail',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
