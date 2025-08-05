import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_explorer/models/pokemon.dart';
import 'package:pokemon_explorer/models/pokemon_type.dart';

class PokeApiService {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  /// Φέρνει τα ονόματα όλων των Pokémon για έναν συγκεκριμένο τύπο
  Future<List<String>> getPokemonNamesByType(PokemonType type) async {
    final typeName = type.title.toLowerCase();

    if (typeName == 'any') {
      final url = Uri.parse('$baseUrl/pokemon?limit=100');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((e) => e['name'] as String).toList();
      } else {
        throw Exception('Failed to fetch Pokémon list');
      }
    }

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

  /// Παίρνει βασικά στοιχεία για ένα Pokémon (όνομα + εικόνα)
  Future<PokemonBasic> getPokemonBasic(String name) async {
    final url = Uri.parse('$baseUrl/pokemon/$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final imageUrl =
          data['sprites']['other']['official-artwork']['front_default'];
      return PokemonBasic(name: name, imageUrl: imageUrl ?? '');
    } else {
      throw Exception('Failed to fetch Pokémon details for $name');
    }
  }

  // detailed pokemon call
  Future<PokemonDetail> getPokemonDetail(String name) async {
    // 1. Basic Pokémon info
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$name'));
    if (response.statusCode != 200) throw Exception('Failed to load Pokémon');

    final data = json.decode(response.body);

    final imageUrl =
        data['sprites']['other']['official-artwork']['front_default'] ?? '';
    final type = data['types'][0]['type']['name'];

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

    // 2. Description (from species)
    final speciesRes = await http.get(
      Uri.parse('$baseUrl/pokemon-species/$name'),
    );
    if (speciesRes.statusCode != 200) throw Exception('Failed to load species');

    final speciesData = json.decode(speciesRes.body);

    final flavorTextEntry = (speciesData['flavor_text_entries'] as List)
        .firstWhere(
          (entry) => entry['language']['name'] == 'en',
          orElse: () => {'flavor_text': 'No description available.'},
        );

    final description = (flavorTextEntry['flavor_text'] as String)
        .replaceAll('\n', ' ')
        .replaceAll('\f', ' ');

    return PokemonDetail(
      name: name,
      imageUrl: imageUrl,
      type: type,
      hp: hp,
      attack: attack,
      defense: defense,
      description: description,
    );
  }
}
