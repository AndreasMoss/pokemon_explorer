import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_explorer/models/pokemon.dart';
import 'package:pokemon_explorer/models/pokemon_type.dart';

class PokeApiService {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  /// Fernei ola ta onomata twn pokemwn gia ena sigkekrimeno typo
  Future<List<String>> getPokemonNamesByType(PokemonType type) async {
    final typeName = type.title.toLowerCase();

    final url = Uri.parse('$baseUrl/type/$typeName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pokemonList = data['pokemon'] as List;
      return pokemonList
          .map((entry) => entry['pokemon']['name'] as String)
          .toList();
    } else {
      throw Exception('Failed to fetch Pokémon of type $typeName');
    }
  }

  /// Onoma + Eikona gia 1 Pokemon gia display sti karta
  Future<PokemonBasic> getPokemonBasic(String name) async {
    final url = Uri.parse('$baseUrl/pokemon/$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final imageUrl =
          data['sprites']['other']['official-artwork']['front_default'] ??
          data['sprites']['other']['official-artwork']['front_shiny'] ??
          data['sprites']['other']['home']?['front_default'] ??
          data['sprites']['other']['dream_world']?['front_default'] ??
          data['sprites']['other']['showdown']?['front_default'] ??
          data['sprites']['other']['showdown']?['back_default'] ??
          "";
      return PokemonBasic(name: name, imageUrl: imageUrl ?? '');
    } else {
      throw Exception('Failed to fetch Pokémon details for $name');
    }
  }

  // detailed pokemon call
  Future<PokemonDetail> getPokemonDetail(String name) async {
    Map<String, dynamic> data;

    // Try fetching from /pokemon/
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$name'));

    print('api call: $baseUrl/pokemon/$name');

    if (response.statusCode == 200) {
      data = json.decode(response.body);
    } else {
      // Try /pokemon-form/
      final formResponse = await http.get(
        Uri.parse('$baseUrl/pokemon-form/$name'),
      );

      if (formResponse.statusCode == 200) {
        final formData = json.decode(formResponse.body);

        final imageUrl = formData['sprites']['front_default'] ?? '';
        return PokemonDetail(
          name: name,
          imageUrl: imageUrl,
          types: ['unknown'], // Τώρα είναι λίστα
          hp: 0,
          attack: 0,
          defense: 0,
          description: 'Details not available for this form.',
        );
      } else {
        throw Exception('Failed to load Pokémon or form data for $name');
      }
    }

    // If we reached here, we have the /pokemon/ data
    final imageUrl =
        data['sprites']['other']['official-artwork']['front_default'] ??
        data['sprites']['other']['official-artwork']['front_shiny'] ??
        data['sprites']['other']['home']?['front_default'] ??
        data['sprites']['other']['dream_world']?['front_default'] ??
        data['sprites']['other']['showdown']?['front_default'] ??
        data['sprites']['other']['showdown']?['back_default'];
    data['sprites']['front_default'] ?? '';

    // pairnoume ola ta types
    final types = (data['types'] as List)
        .map((t) => t['type']['name'] as String)
        .toList();

    final stats = data['stats'] as List;

    int getStat(String statName) {
      return stats.firstWhere(
            (s) => s['stat']['name'] == statName,
            orElse: () => {'base_stat': 0},
          )['base_stat'] ??
          0;
    }

    final hp = getStat('hp');
    final attack = getStat('attack');
    final defense = getStat('defense');

    // Get species info for description
    final speciesRes = await http.get(
      Uri.parse('$baseUrl/pokemon-species/$name'),
    );

    String description = 'This is a special form of the basic Pokémon.';

    if (speciesRes.statusCode == 200) {
      final speciesData = json.decode(speciesRes.body);

      final flavorTextEntry = (speciesData['flavor_text_entries'] as List)
          .firstWhere(
            (entry) => entry['language']['name'] == 'en',
            orElse: () => {'flavor_text': 'No description available.'},
          );

      description = (flavorTextEntry['flavor_text'] as String)
          .replaceAll('\n', ' ')
          .replaceAll('\f', ' ');
    }

    return PokemonDetail(
      name: name,
      imageUrl: imageUrl,
      types:
          types, // itan gia na emfanizoume sta details ola ta types tou pokemon, alla den ilopoiithike
      hp: hp,
      attack: attack,
      defense: defense,
      description: description,
    );
  }
}
